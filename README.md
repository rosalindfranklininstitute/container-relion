# relion

Install as a module share module using `shpc`.

```
# Install
cd /path/to/registry
git clone git@github.com:rosalindfranklininstitute/relion.git
shpc install relion

# Update
cd /path/to/registry/relion
git pull
shpc install relion

# Usage
module load relion

# Run relion gui
relion

# Run relion binaries via the relion-run wrapper
relion-run relion_refine_mpi --help

# Run a script directly calling relion binaries via the relion-run wrapper
relion-run ./run_relion.sh

# Run commands against the container
relion-run which relion
# gives the path within the container to the install location
/usr/local/relion/bin/relion

# Print the module usage help
module help relion
```

This module aliases `relion` for loading the relion gui but does not alias the other relion binaries. 
Run commands or scripts prepended with `relion-run <command>` to access the other binaries or run the benchmark script i.e. `relion-run ./run_relion.sh`. 