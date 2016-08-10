# Fetch the OSM data for Seattle
echo "Downloading the OSM file for Seattle..."
cd build
sleep 3
curl -O https://s3.amazonaws.com/metro-extracts.mapzen.com/seattle_washington.osm.pbf

# Fetch and unzip the USGS NED 1/3 arc-second dataset for the Seattle area
echo "Downloading and extracting the elevation data..."
sleep 3
mkdir -p dem && cd dem
curl -O https://prd-tnm.s3.amazonaws.com/StagedProducts/Elevation/13/ArcGrid/n48w123.zip
unzip ./n48w123.zip && cd grdn48w123_13

# Convert the NED data (in ArcGrid .adf format) to ASCII (ArcGrid ASCII)
echo "Converting the elevation data into an ASCII format..."
sleep 3
gdal_translate -of AAIGrid -a_srs EPSG:4326 w001001.adf w001001.txt

# For whatever reason, I can only get osrm to work if the raster data is stored
# as integers - so we'll round to the nearest meter. It also requires that the
# data be *solely* in a tsv-ish format, so the 6 header lines containing
# metadata need to be stripped. This could be done in bash, but is easier in
# python
echo "Converting ArcGrid ASCII to OSRM raster format (can take a while)"
python ../../../ascii2osrm.py ./w001001.txt ../../seattle.asc
