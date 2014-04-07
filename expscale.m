function dps = expscale(cue, list, gradient)

dps = gradient.^(abs(cue-list));