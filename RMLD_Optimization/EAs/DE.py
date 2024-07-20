import numpy as np
from copy import deepcopy


def DE_exe(subPop, group, func, context, MaxIter, scale, Optimum):
    NIND = len(subPop)
    tPop = np.array([context] * NIND)

    # Embedding the sub-population to context vector
    for i in range(len(group)):
        tPop[:, group[i]] = subPop[:, i]
    tPopFit = np.zeros(NIND)
    for i in range(NIND):
        tPopFit[i] = func(tPop[i])
        Optimum = min(tPopFit[i], Optimum)

    # Optimization
    for maxiter in range(MaxIter):
        Xbest = tPop[np.argmin(tPopFit)]
        for i in range(NIND):
            candi = list(range(NIND))
            candi.remove(i)
            r1, r2 = np.random.choice(candi, 2, replace=False)  # Mutation
            Off = tPop[i] + np.random.normal(0.5, 0.3) * (Xbest - tPop[i]) + np.random.normal(0.5, 0.3) * (tPop[r1] - tPop[r2])
            CheckIndi(Off, scale)

            jrand = np.random.randint(0, len(context))
            for j in range(len(context)):  # Crossover
                Cr = np.random.normal(0.5, 0.3)
                if np.random.rand() < Cr or j == jrand:
                    Off[j] = tPop[i][j]

            OffFit = func(Off)
            Optimum = min(OffFit, Optimum)
            if OffFit < tPopFit[i]:
                tPop[i] = deepcopy(Off)
                tPopFit[i] = OffFit

    bestPop = tPop[np.argmin(tPopFit)]
    bestSubPop = np.zeros(len(group))
    returnPop = np.zeros_like(subPop)
    for i in range(len(group)):
        bestSubPop[i] = bestPop[group[i]]
        returnPop[:, i] = tPop[:, group[i]]
    return bestSubPop, returnPop, Optimum


def CheckIndi(Indi, scale):
    range_width = scale[1] - scale[0]
    Dim = len(Indi)
    for i in range(Dim):
        if Indi[i] > scale[1]:
            n = int((Indi[i] - scale[1]) / range_width)
            mirrorRange = (Indi[i] - scale[1]) - (n * range_width)
            Indi[i] = scale[1] - mirrorRange
        elif Indi[i] < scale[0]:
            n = int((scale[0] - Indi[i]) / range_width)
            mirrorRange = (scale[0] - Indi[i]) - (n * range_width)
            Indi[i] = scale[0] + mirrorRange
        else:
            pass


