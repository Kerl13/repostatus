# Repostatus

Run `git status` in every git repository under `~/git/` and display a nice
summary of leftover files, untracked changes and commits that have not been
pushed to a remote.

The output looks like (the colors are not rendered here):

```
==========================( Repostatus )==========================
==( dotfiles )========================================( Failed )==
On branch master
Your branch is up to date with 'origin/master'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   submodules/vimmic (new commits)

no changes added to commit (use "git add" and/or "git commit -a")
==( repostatus )======================================( Failed )==
On branch master
Your branch is up to date with 'origin/master'.

Untracked files:
  (use "git add <file>..." to include in what will be committed)

	README.md

nothing added to commit but untracked files present (use "git add" to track)
==( AsciiMath )===========================================( Ok )==
==( sage )================================================( Ok )==
==( rustre )==============================================( Ok )==
==( fun_with_types )======================================( Ok )==
==( git-trac-command )====================================( Ok )==
==( tree-sitter-menhir )==================================( Ok )==
==( expr_gadt )===========================================( Ok )==
==( recschemes )===================================( No remote )==

[...]

==( les-boloss/skeleton )=================================( Ok )==
==( les-boloss/hashcode19 )===============================( Ok )==
==( les-boloss/madcast )==================================( Ok )==
==( les-boloss/zipper )===================================( Ok )==
=============================( Done )=============================
==========================( 45 / 1 / 2 )==========================
```
