# Baie-de-Somme

## How to install it

To install the latest stable version of the model, go to the Playground (Ctrl+OP) in your Pharo image and execute the following Metacello script (select it and press Do-it button or Ctrl+D):

```st
Metacello new
    repository: 'github://cormas/cormas';
    baseline: 'Cormas';
    load.

Metacello new
    repository: 'github://pierreScemama/Baie-de-Somme:main';
    baseline: 'Baie de Somme-Model';
    load.
```
