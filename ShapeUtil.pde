import java.awt.geom.AffineTransform;
import java.awt.geom.Area;
import java.awt.geom.GeneralPath;
import java.awt.geom.PathIterator;
import java.awt.geom.Rectangle2D;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.PriorityQueue;
import java.util.Vector;

import org.jbox2d.common.Vec2;
import org.newdawn.slick.geom.Polygon;
import org.newdawn.slick.geom.Vector2f;

/**
 * Shape utility functions.
 */
public static class ShapeUtil
{
    /**
     * A polygon segment (edge) used internally.
     */
    private static class Segment
    {
        public Vec2 start, end, delta;

        public Segment(Vec2 start, Vec2 end)
        {
            this.start = start;
            this.end = end;
            delta = this.end.sub(this.start);
        }
    }

    // Use this queue to store parts that still need to be checked
    /** The queue. */
    private static ArrayDeque<Vector<Vec2>> queue = new ArrayDeque<Vector<Vec2>>();

    /**
     * Converts an AWT Area to Slick Polygons. A list is needed since an area
     * can consist of multiple polygons. General idea and some code was adapted
     * from http://slick.javaunlimited.net/viewtopic.php?t=1256
     * 
     * @param area
     *            The AWT Area
     * @return A list of Slick Polygons
     */
    public static ArrayList<Polygon> areaToPolygon(Area area)
    {
        final ArrayList<Polygon> polys = new ArrayList<Polygon>();

        final PathIterator pi = area.getPathIterator(new AffineTransform());

        int pcount = 0;

        Polygon poly = new Polygon();
        while (!pi.isDone())
        {
            final float[] point = new float[2];
            final int type = pi.currentSegment(point);

            if (type == PathIterator.SEG_LINETO)
            {
                pcount++;
                poly.addPoint(point[0], point[1]);
            }
            else if (type == PathIterator.SEG_MOVETO)
            {
                // Start of a new polygon, add it to the list
                if (pcount > 2)
                {
                    polys.add(poly);
                }
                pcount = 1;

                poly = new Polygon();
                poly.addPoint(point[0], point[1]);
            }

            pi.next();
        }

        if (pcount > 2)
        {
            polys.add(poly);
        }

        return polys;
    }

    /**
     * Checks to vectors for equality in an epsilon environment (leaves room for
     * errors)
     * 
     * @param a
     *            One vector
     * @param b
     *            And the other
     * @return True, if equal
     */
    public static boolean deltaEquals(Vec2 a, Vec2 b)
    {
        return a.sub(b).lengthSquared() < 0.1;
    }

    /**
     * Attempt splitting the polygon by extending the given segment until it
     * hits on of the other edges. Then we have two parts which are closer to
     * being convex.
     * 
     * @param vectors
     *            The polygon vectors
     * @param ray
     *            The ray segment
     * @param split_idx
     *            Where to split
     * @return True, if successful
     */
    private static boolean doRaySplit(Vector<Vec2> vectors, Segment ray, int split_idx)
    {
        final int last_vertex = vectors.size() - 1;

        // We need to exclude the ray segment from the search
        final int last_idx = split_idx == 0 ? last_vertex : split_idx - 1;

        // To use the closest segment for ray intersection order them by
        // distance. Using the closest prevents the cut to go through any
        // unwanted segments.
        float min_distance = Float.MAX_VALUE;

        int hit_start = -1;
        int hit_end = -1;
        Vec2 hit_point = null;

        // For each segment in the polygon
        for (int start_idx = 0; start_idx < vectors.size(); start_idx++)
        {
            // Calculate the index of the end vertex
            final int end_idx = start_idx == last_vertex ? 0 : start_idx + 1;

            // Ignore the ray segment and the one after it
            if (start_idx == split_idx || start_idx == last_idx)
            {
                continue;
            }

            // Try casting a ray along the problematic segment which if
            // successful
            // can be used to split up the polygon along it
            final Vec2 res = ShapeUtil.hitRay(ray, new Segment(
                vectors.get(start_idx), vectors.get(end_idx)));

            if (res != null)
            {
                // Hit another segment, so check if it's the closest one
                final float distance = res.sub(ray.end).lengthSquared();

                // This one is closer to the original
                if (distance < min_distance)
                {
                    hit_point = res;
                    min_distance = distance;
                    hit_start = start_idx;
                    hit_end = end_idx;
                }
            }
        }

        // Yay! Lets cut it up!
        if (hit_start != -1)
        {
            // Prepare the parts
            final Vector<Vec2> part_a = new Vector<Vec2>();
            final Vector<Vec2> part_b = new Vector<Vec2>();

            // Only add the new points if they are to far from the end/start of
            // the associated segment
            if (!ShapeUtil.deltaEquals(vectors.get(hit_end), hit_point))
            {
                part_a.add(hit_point);
            }
            if (!ShapeUtil.deltaEquals(vectors.get(hit_start), hit_point))
            {
                part_b.add(hit_point);
            }

            // Build the parts which both contain the new found cut as an edge
            for (int j = hit_end; j != split_idx; j = (j == last_vertex) ? 0 : j + 1)
            {
                part_a.add(vectors.get(j));
            }
            for (int j = split_idx; j != hit_end; j = (j == last_vertex) ? 0 : j + 1)
            {
                part_b.add(vectors.get(j));
            }

            // And check those new parts for convexity
            ShapeUtil.queue.add(part_a);
            ShapeUtil.queue.add(part_b);

            return true;
        }

        return false;
    }

    /**
     * Flip the vertices order of the polygon.
     * 
     * @param poly
     *            The polygon
     * @return The polygon with flipped order
     */
    public static Polygon flip(Polygon poly)
    {
        final float[] points = poly.getPoints();

        final Polygon new_poly = new Polygon();

        // Walk from last to first...
        for (int i = points.length - 1; i > 0; i -= 2)
        {
            new_poly.addPoint(points[i - 1], points[i]);
        }

        return new_poly;
    }

    public static Vector2f getCentroid(Polygon poly)
    {
        float sum = 0;
        float cx = 0;
        float cy = 0;

        final int max = poly.getPointCount() - 1;

        for (int i = 0; i < poly.getPointCount(); i++)
        {
            final float[] point1 = poly.getPoint(i);
            final float[] point2 = poly.getPoint(i == max ? 0 : i + 1);

            final float cross = (point1[0] * point2[1] - point2[0] * point1[1]);

            cx += (point1[0] + point2[0]) * cross;
            cy += (point1[1] + point2[1]) * cross;

            sum += cross;
        }

        cx /= 3 * sum;
        cy /= 3 * sum;

        return new Vector2f(cx, cy);
    }

    public static float getSignedArea(Polygon poly)
    {
        float sum = 0;
        final int max = poly.getPointCount() - 1;

        // Basically calculate half the signed area of the polygon
        for (int i = 0; i < poly.getPointCount(); i++)
        {
            final float[] point1 = poly.getPoint(i);
            final float[] point2 = poly.getPoint(i == max ? 0 : i + 1);

            sum += (point1[0] * point2[1] - point2[0] * point1[1]);
        }

        // If the sign of the area is negative, the order is counter-clockwise
        return sum / 2;
    }

    /**
     * Handle's a polygon during the convex making process. Attempts to split it
     * up if it is not convex. Otherwise returns the original polygon.
     * 
     * @param vectors
     *            The polygon vectors
     * @return The original polygon if it was convex, null otherwise
     */
    private static Polygon handlePolygon(Vector<Vec2> vectors)
    {
        final int last_vertex = vectors.size() - 1;
        boolean is_convex = true;

        if (vectors.size() == 3) return ShapeUtil.makePolygon(vectors);

        // Walk through all vertices until we find a concave one
        for (int current_idx = 0; current_idx < vectors.size(); current_idx++)
        {
            // Grab a triplet of vertices
            final int last_idx = current_idx == 0 ? last_vertex : current_idx - 1;
            final int next_idx = current_idx == last_vertex ? 0 : current_idx + 1;

            final Vec2 last = vectors.get(last_idx);
            final Vec2 current = vectors.get(current_idx);
            final Vec2 next = vectors.get(next_idx);

            // Use the cross product to determine if the current vertex is at a
            // concave position
            // If cross product is negative, the vertex is not convex, so we
            // need to split here
            if (Vec2.cross(current.sub(last), next.sub(current)) < 0)
            {
                is_convex = false;
                final Segment ray = new Segment(last, current);

                // Try splitting the polygon up by ray casting at the current
                // vertex
                if (ShapeUtil.doRaySplit(vectors, ray, current_idx))
                {
                    break;
                }
                else throw new Error("Invalid shape - no overlapping allowed!");
            }
        }

        // Only return the polygon if it was convex anyway
        return is_convex ? ShapeUtil.makePolygon(vectors) : null;
    }

    /**
     * Performs a raycast from end point of the given ray segment in direction
     * of the segment and checks if it hits the given target segment. The
     * formula was adapted from
     * http://www.faqs.org/faqs/graphics/algorithms-faq/
     * 
     * @param ray
     *            The segment used as basis for the ray
     * @param segment
     *            The targeted segment
     * @return The position where the ray hit or null if it misses
     */
    private static Vec2 hitRay(Segment ray, Segment segment)
    {
        // See http://www.faqs.org/faqs/graphics/algorithms-faq/
        final float ray_numerator = Vec2.cross(segment.delta, ray.start.sub(segment.start));
        final float segement_numerator = Vec2.cross(ray.delta, ray.start.sub(segment.start));

        final float denominator = Vec2.cross(ray.delta, segment.delta);

        // Segment and ray are parallel
        if (denominator == 0) return null;

        final float ray_pos = ray_numerator / denominator;
        final float segement_pos = segement_numerator / denominator;

        // The potential hit point is not actually on the segment
        if (segement_pos < 0 || segement_pos > 1) return null;

        // The hit point would be in opposite direction of the ray
        if (ray_pos <= 0) return null;

        // Calculate the hit point
        return ray.start.add(ray.delta.mul(ray_pos));
    }

    /**
     * Checks if the vertices of a polygon are in counter-clockwise order.
     * Algorithm taken from http://paulbourke.net/geometry/clockwise/index.html
     * 
     * @param poly
     *            The polygon
     * @return true, if the vertices of the polygon are in counter-clockwise
     *         order
     */
    public static boolean isCCW(Polygon poly)
    {
        float sum = 0;
        final int max = poly.getPointCount() - 1;

        // Basically calculate half the signed area of the polygon
        for (int i = 0; i < poly.getPointCount(); i++)
        {
            final float[] point1 = poly.getPoint(i);
            final float[] point2 = poly.getPoint(i == max ? 0 : i + 1);

            // sum += (point2[0] - point1[0]) * (point2[1] + point1[1]);
            sum += (point1[0] * point2[1] - point2[0] * point1[1]);
        }

        // If the sign of the area is negative, the order is counter-clockwise
        return sum > 0;
    }

    /**
     * Checks if the given polygon is convex. Order of vertices does not matter
     * for this check.
     * 
     * @param poly
     *            The polygon
     * @return True, if the polygon is convex
     */
    public static boolean isConvex(Polygon poly)
    {
        boolean is_positive = false;
        final int max = poly.getPointCount() - 1;

        for (int i = 0; i < poly.getPointCount(); ++i)
        {
            // Grab triplet of points
            final float[] last = poly.getPoint((i == 0) ? max : i - 1);
            final float[] point = poly.getPoint(i);
            final float[] next = poly.getPoint((i == max) ? 0 : i + 1);

            // Get distances
            final float dx0 = point[0] - last[0];
            final float dy0 = point[1] - last[1];
            final float dx1 = next[0] - point[0];
            final float dy1 = next[1] - point[1];

            final float cross = dx0 * dy1 - dx1 * dy0;

            // Cross product should have same sign for each vertex if the
            // polygon is convex.
            if (i == 0)
            {
                is_positive = cross > 0;
            }
            else if ((cross > 0) != is_positive) return false;
        }
        return true;
    }

    /**
     * Split a concave polygon up into convex parts. Useful if you want to use
     * more complex shapes in Box2D.
     * 
     * @param poly
     *            The concave polygon
     * @return A list of convex polygons
     */
    public static ArrayList<Polygon> makeConvex(Polygon poly)
    {
        // Use this list for finished convex polygon results
        final ArrayList<Polygon> result = new ArrayList<Polygon>();

        ShapeUtil.queue.clear();

        // Make sure there are no unnecessary vertices as the algorithm might
        // not work otherwise
        poly = ShapeUtil.simplify(poly);

        // If the simplification of the polygon is invalid return empty result
        if (poly == null) return result;

        // Make sure the vertices are in counter-clockwise order
        if (!ShapeUtil.isCCW(poly))
        {
            poly = ShapeUtil.flip(poly);
        }

        // Start off with the given polygon
        ShapeUtil.queue.add(ShapeUtil.makeVectors(poly));

        while (ShapeUtil.queue.size() > 0)
        {
            // See if the polygon needs splitting and do it
            poly = ShapeUtil.handlePolygon(ShapeUtil.queue.remove());

            // The polygon was convex so we simply add it
            if (poly != null)
            {
                poly = ShapeUtil.simplify(poly);

                result.add(poly);
            }
        }

        return result;
    }

    /**
     * Turns a list of Box2D vectors into a Shape2D polygon.
     * 
     * @param vectors
     *            The vectors
     * @return The polygon
     */
    public static Polygon makePolygon(Vector<Vec2> vectors)
    {
        final Polygon poly = new Polygon();

        for (final Vec2 vector : vectors)
        {
            poly.addPoint(vector.x, vector.y);
        }

        return poly;
    }

    /**
     * Turns a Shape2D polygon into a list of Box2D vectors.
     * 
     * @param poly
     *            The polygon
     * @return The vectors
     */
    private static Vector<Vec2> makeVectors(Polygon poly)
    {
        final Vector<Vec2> vectors = new Vector<Vec2>();

        for (int i = 0; i < poly.getPointCount(); i++)
        {
            final float[] point = poly.getPoint(i);

            vectors.add(new Vec2(point[0], point[1]));
        }

        return vectors;
    }

    /**
     * Merge a list of polygons. The polygons are merged so that the ones
     * contained within others are subtracted from the containing one. This is
     * done by order of size so that it is possible to recursively have polygons
     * with holes inside the holes of bigger polygons etc.
     * 
     * @param polys
     *            The polygons that should be merged
     * @return A list of the merged polygons
     */
    public static ArrayList<Polygon> merge(Collection<Polygon> polys)
    {
        final ArrayList<Polygon> merged = new ArrayList<Polygon>();

        // A PriorityQueue is used to sort the polygons by their size
        final PriorityQueue<Polygon> coll_set = new PriorityQueue<Polygon>(
            20, new Comparator<Polygon>()
            {
                @Override
                public int compare(Polygon arg0, Polygon arg1)
                {
                    final int size0 = (int) (arg0.getHeight() * arg0.getWidth());
                    final int size1 = (int) (arg1.getHeight() * arg1.getWidth());

                    return size1 - size0;
                }
            });

        coll_set.addAll(polys);

        // The biggest polygon is handled first
        Polygon highest = coll_set.poll();

        // Handle all polygons
        while (highest != null)
        {
            // Check all remaining (smaller) polygons against the biggest one
            for (final Polygon poly : coll_set)
            {
                if (highest.contains(poly))
                {
                    // If the biggest polygon contains any of the other
                    // polygons, the other
                    // is considered to be a hole and subtracted from the
                    // biggest one
                    coll_set.remove(poly);
                    coll_set.addAll(ShapeUtil.subtract(highest, poly));

                    // Don't add the biggest one since it has been split up and
                    // each part
                    // will be checked again
                    highest = null;

                    break;
                }
            }

            if (highest != null)
            {
                // Polygon is fully handled, so add it
                merged.add(highest);
            }

            // Check the next biggest polygon
            highest = coll_set.poll();
        }

        return merged;
    }

    /**
     * Converts a Slick Polygon to an AWT Area.
     * 
     * @param poly
     *            The Slick Polygon
     * @return The AWT Area
     */
    public static Area polygonToArea(Polygon poly)
    {
        return new Area(ShapeUtil.polygonToPath(poly));
    }

    /**
     * Converts a Slick Polygon to an AWT Path. General idea and some code was
     * adapted from http://slick.javaunlimited.net/viewtopic.php?t=1256
     * 
     * @param poly
     *            The Slick Polygon
     * @return The AWT Path
     */
    public static GeneralPath polygonToPath(Polygon poly)
    {
        final GeneralPath path = new GeneralPath();

        for (int i = 0; i < poly.getPointCount(); i++)
        {
            final float[] point = poly.getPoint(i);

            if (i == 0)
            {
                path.moveTo(point[0], point[1]);
            }
            else
            {
                path.lineTo(point[0], point[1]);
            }
        }

        return path;
    }

    /**
     * Simplifies a polygon by removing unnecessary vertices on an edge.
     * 
     * @param poly
     *            The polygon
     * @return The simplified polygon
     */
    public static Polygon simplify(Polygon poly)
    {
        final Polygon simple = new Polygon();

        final int max = poly.getPointCount() - 1;
        int pcount = 0;

        for (int i = 0; i < poly.getPointCount(); i++)
        {
            // Grab the points next to the current one
            final float[] last = (i == 0) ? poly.getPoint(max) : poly.getPoint(i - 1);
            final float[] point = poly.getPoint(i);
            final float[] next = (i == max) ? poly.getPoint(0) : poly.getPoint(i + 1);

            // Calculate the gradient the two edges at the current point
            final float gradient1 = (last[0] - point[0]) / (last[1] - point[1]);
            final float gradient2 = (point[0] - next[0]) / (point[1] - next[1]);

            // Only add points which is at an angle
            if (gradient1 != gradient2)
            {
                pcount++;
                simple.addPoint(point[0], point[1]);
            }
        }

        return pcount > 2 ? simple : null;
    }

    /**
     * Subtract one polygon from an other one. Since this only works with the
     * slick polygons which don't support holes, the polygon with the hole is
     * split up into an upper and a lower half which are hole-free again.
     * Notice: The result list can contain more than just two polygons, if the
     * hole is more complicated! For the whole process the java.awt.geom library
     * is used instead of trying to create something crappy here myself :D.
     * General idea and some code was adapted from
     * http://slick.javaunlimited.net/viewtopic.php?t=1256
     * 
     * @param poly
     *            The bigger polygon
     * @param hole
     *            The polygon used as hole
     * @return The resulting polygons
     */
    public static ArrayList<Polygon> subtract(Polygon poly, Polygon hole)
    {
        // Convert to java.awt.geom stuff
        final Area poly_area = ShapeUtil.polygonToArea(poly);
        final Area hole_area = ShapeUtil.polygonToArea(hole);

        final Rectangle2D poly_bounds = poly_area.getBounds2D();
        final Rectangle2D hole_bounds = hole_area.getBounds2D();

        // Split the bounding box of the polygon up into a top and a bottom half
        // with the cut
        // crossing the center of the hole
        final Area top_rect = new Area(new Rectangle2D.Double(
            poly_bounds.getX(), poly_bounds.getY(), poly_bounds.getWidth(),
            hole_bounds.getCenterY() - poly_area.getBounds2D().getY()));
        final Area bottom_rect = new Area(new Rectangle2D.Double(
            poly_bounds.getX(), hole_bounds.getCenterY(), poly_bounds.getWidth(),
            poly_bounds.getHeight()));

        // Cut and slice!
        final Area top_area = (Area) poly_area.clone();
        top_area.intersect(top_rect);
        top_area.subtract(hole_area);

        final Area bottom_area = (Area) poly_area.clone();
        bottom_area.intersect(bottom_rect);
        bottom_area.subtract(hole_area);

        final ArrayList<Polygon> polys = new ArrayList<Polygon>();

        // Convert back...
        polys.addAll(ShapeUtil.areaToPolygon(top_area));
        polys.addAll(ShapeUtil.areaToPolygon(bottom_area));

        return polys;
    }
}
