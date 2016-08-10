# Build
echo "Compiling OSRM..."
sleep 3
mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build .

# Set up the profile(s)
cp -r ../profiles/ .
cp ../seattle-wheelchair.lua ./profiles/
ln -sf profiles/seattle-wheelchair.lua ./profile.lua
