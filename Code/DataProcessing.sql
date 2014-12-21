-- Import depth points and river grid into PostGIS

--Transform depth points to river coordinates (SN coordinates)

create table points_sn as 
select
points.gid,
points.bed_elevat as depth,
st_distance(line.geom, points.geom) as N, 
st_line_locate_point(st_linemerge(line.geom), points.geom) * st_length(st_linemerge(line.geom)) as S,
points.easting as X,
points.northing as Y,
st_makepoint(st_distance(line.geom, points.geom), st_line_locate_point(st_linemerge(line.geom), points.geom) * st_length(st_linemerge(line.geom))) as geom
from referenceline_smoothed as line, willamette_points_subset as points


--Transform river grid to river coordinates (SN coordinates)

create table rivergrid_sn as 
select
points.gid,
st_distance(line.geom, points.geom) as N, 
st_line_locate_point(st_linemerge(line.geom), points.geom) * st_length(st_linemerge(line.geom)) as S,
st_makepoint(st_distance(line.geom, points.geom), st_line_locate_point(st_linemerge(line.geom), points.geom) * st_length(st_linemerge(line.geom))) as geom
from referenceline_smoothed as line, gridpoints_river_5m as points

--Update the geometry columns of both sn datasets
SELECT Populate_Geometry_Columns();
SELECT UpdateGeometrySRID('public', 'points_sn', 'geom', 26710);
SELECT UpdateGeometrySRID('public', 'rivergrid_sn', 'geom', 26710);
-- then refresh the table to Vacuum it

--Bring the translated depth and river grid (SN) into R
--Run Kriging.R
--Import the resulting shapefile into PostGIS

--Translate the SN coordinates of krigedpoints.shp into realworld coordinates

UPDATE gridpoints_river_5m 
SET estimates = krigedpoints_all.estimates
FROM krigedpoints_all
WHERE gridpoints_river_5m.gid=krigedpoints_all.gid



