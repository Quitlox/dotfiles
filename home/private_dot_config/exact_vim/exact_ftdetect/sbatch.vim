" .sbatch is a filetype used by slurm, software for managing and running jobs
" on computing clusters.
au BufNewFile,BufRead *.sbatch setfiletype bash
