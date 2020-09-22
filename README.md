# Ray Tracing In Julia

A software ray tracing engine based off the book 'The Ray Tracer Challenge' by Jamis Buck.

The current state is very similar to that described in the book, with some optimisations. For instance, this design uses Julia's linear algebra library rather than implementing the routines as described in the book. This provides an order of magnitude performance improvement. 

In time, as the engine becomes more complex, other features of Julia will be used. For example, using multicore rendering could give near linear performance benefits in rendering time.

As this is a software renderer, it will never be fast enough for real time graphics. The project could eventually extend to offloading compute to an FPGA, but that is very far off. 

![Example render](https://github.com/EdwardStables/julia_ray_tracing/blob/master/demo/animate.gif)
