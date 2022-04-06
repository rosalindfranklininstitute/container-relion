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

This module aliases `mpirun` within the container in addition to the `/usr/local/relion/bin/*` binaries. If you want to use a different (compatible) mpi build then you will need to force it using environment variables and/or loading another module after `module load relion`. 