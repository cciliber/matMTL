#Readme

Multi Task Learning Package for Matlab. Code implementing the work in 

> Ciliberto, Carlo, Tomaso Poggio, and Lorenzo Rosasco. *[Convex Learning of Multiple Tasks and their Structure.](http://arxiv.org/pdf/1504.03101.pdf)* **International Conference on Machine Learning (ICML), 2015.**


##Installation & Usage

Just `addpath('learning-machine')` to your MATLAB path. An example of how to use the package is in the file `main.m`.

##A couple of words on the package

1. The goal/scope of our work was to present a general convex framework for multi-task learning, which would allow on one hand to capture several previous approaches proposed in Multi-task Learning (e.g. Argyriou '08, Jacob '09, Zhang '10, Dinuzzo '11, etc.) and on the other hand offer a general (meta) block coordinate strategy to solve problems of this form, with guarantees to converge to the global minimum. The code in this repository consists in the implementation of such a meta-strategy for some of these multi-task settings.

2. The package has been designed with the intention of being be plug-and-play, however it is not yet ready for distribution and unfortunately still not documented. In particular the *parameter selection* routine is available but there's no documentation at all. **TBD!**

###References
[1] Argyriou, Andreas, Theodoros Evgeniou, and Massimiliano Pontil. "Convex multi-task feature learning". Machine Learning, 2008.

[2] Jacob, Laurent, Jean-philippe Vert, and Francis R. Bach. "Clustered multi-task learning: A convex formulation." Advances in neural information processing systems, 2009.

[3] Zhang, Yu, and Dit-Yan Yeung. "A convex formulation for learning task relationships in multi-task learning." International Conference on Machine Learning (ICML), 2012.

[4] Dinuzzo, Francesco, Cheng S. Ong, Gianluigi Pillonetto, and Peter V. Gehler. "Learning output kernels with block coordinate descent." Proceedings of the 28th International Conference on Machine Learning (ICML), 2011.
