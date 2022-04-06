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
```

This module aliases `relion` for loading the relion gui but does not alias the other relion binaries. 
Run commands or scripts prepended with `relion-run <command>` to access the other binaries or run the benchmark script i.e. `relion-run ./run_relion.sh`. 