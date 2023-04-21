

# WW3-Lambda
Wave breaking model within the framework of Phillips' Lambda implemented in WaveWatchIII.

Romero, Leonel. 2019. “Distribution of Surface Wave Breaking Fronts.” Geophysical Research Letters, September, 2019GL083408. https://doi.org/10.1029/2019GL083408.

# Release v2.1.0 (April 21, 2023)
The latest release v2.1.0 fixes a significant issue related to the direction of the dissipation's modulation transfer function, which initially used a scalar mean direction weighted by the energy spectrum, leading to unrealistic growth of the spectral tail in conditions with misaligned winds and dominant waves.

This fix increases the computational cost slightly by about 6%.

The files updated are: w3srcxmd.ftn w3srcemd.ftn ww3_ounp.ftn ww3_outp.ftn gx_outp.ftn
