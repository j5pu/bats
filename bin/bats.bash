# shellcheck shell=bash

#
# Bats Core Variables

# <html><h2>Add timing information to tests </h2>
# <p><strong><code>$BATS_ENABLE_TIMING</code></strong>.</p>
# <p><strong><code>bats --timing</code></strong></p>
# <a href="https://bats-core.readthedocs.io/en/stable/usage.html#parallel-execution">parallel-execution</a>
# </html>
export BATS_ENABLE_TIMING

# Library directory:
# Applications/PyCharm.app/Contents/bin/plugins/bashsupport-pro/bats-core/libexec/bats-core
export BATS_LIBEXEC

# <html><h2>Serialize test file execution instead of running them in parallel </h2>
# <p><strong><code>$BATS_NO_PARALLELIZE_ACROSS_FILES</code></strong> (requires --jobs >1).</p>
# <p><strong><code>bats --no-parallelize-across-files</code></strong></p>
# <a href="https://bats-core.readthedocs.io/en/stable/usage.html#parallel-execution">parallel-execution</a>
# </html>
export BATS_NO_PARALLELIZE_ACROSS_FILES

# <html><h2>Disable Parallelize within a single file </h2>
# <p><strong><code>$BATS_NO_PARALLELIZE_WITHIN_FILE</code></strong> true (bool) in 'setup_file()' disables for file.</p>
# <p><strong><code>bats --no-parallelize-within-files</code></strong></p>
# <a href="https://bats-core.readthedocs.io/en/stable/usage.html#parallel-execution">parallel-execution</a>
# </html>
export BATS_NO_PARALLELIZE_WITHIN_FILE

# <html><h2>Number of parallel jobs (requires GNU parallel) </h2>
# <p><strong><code>$BATS_NUMBER_OF_PARALLEL_JOBS</code></strong></p>
# <p><strong><code>bats --jobs <jobs></code></strong></p>
# <a href="https://bats-core.readthedocs.io/en/stable/usage.html#parallel-execution">parallel-execution</a>
# </html>
export BATS_NUMBER_OF_PARALLEL_JOBS

# Output file:
# /var/folders/3c/k3_3r82s08q31699vdnxd2s00000gp/T/bats-run-6576/bats.6612.out
export BATS_OUT

# Name (not a file/file):
# /var/folders/3c/k3_3r82s08q31699vdnxd2s00000gp/T/bats-run-7204/bats.7229
export BATS_PARENT_TMPNAME

# The repository of bats-core :
# /Applications/PyCharm.app/Contents/bin/plugins/bashsupport-pro/bats-core
export BATS_ROOT

# Source file generated from the bats file:
# /var/folders/3c/k3_3r82s08q31699vdnxd2s00000gp/T/bats-run-7606/bats.7632.src
export BATS_TEST_SOURCE

# Temp file name under $BATS_RUN_TMPDIR (not created):
# /var/folders/3c/k3_3r82s08q31699vdnxd2s00000gp/T/bats-run-7606/bats.7642
export BATS_TMPNAME
