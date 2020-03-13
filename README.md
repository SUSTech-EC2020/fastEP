# fastEP

This project is a reproduced work of the paper [Evolutionary Programming Made Faster](https://ieeexplore.ieee.org/document/771163/). 

This paper should be cited if code from this project is used in any way:

```
@article{yao1999evolutionary,
  title={Evolutionary programming made faster},
  author={Yao, Xin and Liu, Yong and Lin, Guangming},
  journal={IEEE Transactions on Evolutionary computation},
  volume={3},
  number={2},
  pages={82--102},
  year={1999},
  publisher={IEEE}
}
```

This project is used for teaching the course **CS408/CSE5012: Evolutionary Computation and Its Applications** at the Southern University of Science and Technology (SUSTech), Shenzhen, China.

*Not 100% sure that it is bug-free. Use at your own risk!*

## Some Details

- Classic Evolutionary Programming (CEP) uses a Gaussian and Fast Evolutionary Programming (FEP) uses a Cauchy distribution for mutation.
- Set values to bounds for points which are out of bounds.
- A fixed lower bound is set for step-size.
- The individual is mutated first then mutate the step-size.

The programs will also output formatted Latex table for results and plots of evolutionary curves. Examples as follows.

![Optimising f1: Best of population, f1](/figures/f1-best-crop.pdf)
![Optimising f1: Average of population](/figures/f1-avg-crop.pdf)


## Lab 4: Explore how search operators and implementation details affect an EA’s performance.

### Task
- We have seen how the performance of an EA changes when using a Cauchy, instead of Gaussian, to sample random perturbation to generate offspring.
- There are many details which affect an EA's performance:
  - Distributions used to sample random perturbation to generate offspring (cf. pages 8-10, 37 of the slides for Lecture 4)
  - Techniques for handle points out of bounds
  - Set a fix / an adaptive lower bound for $\eta$ or not (cf. pages 39-40 of the slides for Lecture 4)
  - Mutate $\x$ first or mutate $\eta$ first  (cf. Eqs. (2) and (3) on page 9 of the slides for Lecture 4)
  - Mix search biases by self-adaptation (cf. pages 34-36 of the slides for Lecture 4)
  
  (More details can be found in the slides for Lecture 4!)

In this lab, we will exxplore how **search operators** and **implementation details** affect an EA's performance.

### Results and Discussion (to be filled by students)

* Use Levy Distribution to sample random perturbation to generate offspring (蒋如意)

* Handling bounds of search space:
  * When a point is outside of bounds, re-sample it till being inside (谭浩)
  * Using a projection to map $(-\infty,\infty)$ to $[lb,ub]$ (裴季源)
* Use mutation step-size to adjust lower bounds for $\eta$ (欧阳奕成)
* Mutate $\eta$ first then mutate $\x$ (赵志翔)
* Mix search biases by self-adaptation
  * Generate 2 offspring using Cauchy and Gaussian, take the fitter one (IFEP) (张清泉)
  * Use mean mutation operator (吴钰)
  * Use adaptive mutation operator (潘超)
