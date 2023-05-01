if exists("did_load_filetypes")
    finish
endif

augroup filetypedetect

    au BufNewFile,BufRead ~/.config/i3/config set filetype=i3config
    " The .mpc file extendsion is used by the MP-SPDZ framework
    " https://github.com/data61/MP-SPDZ
    au! BufNewFile,BufRead *.mpc setfiletype python
    au! BufNewFile,BufRead ~/.config/polybar/config set filetype=dosini
    au! BufRead,BufNewFile *.sage,*.spyx,*.pyx setfiletype python
    " .sbatch is a filetype used by slurm, software for managing and running jobs
    " on computing clusters.
    au! BufNewFile,BufRead *.sbatch setfiletype bash
    au! BufNewFile,BufRead ~/.config/Code/User/settings.json set filetype=jsonc
    au! BufNewFile,BufRead launch.json set filetype=jsonc

augroup END
