# Conway's game of Life - TDD as if you mean it

This is a step by step TDD implementation of conway's game of life

## How to use this repo
First check out the screenshots in "doc - first steps" folder

Then start following the git commit history

## TODO
the commit "implement: add an optional caching action before the tick"
is increasing the complexity of the class, and it would be an interesting
case to find a way to extract the caching logic out of the Cell
The cell should not care about saving history about it's neighbours

probably a middle man between the Cell and the Game could help here.
