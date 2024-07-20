import scipy.io as sio


def RMLD(RMLD_path):
    RMLD_seps = list(sio.loadmat(RMLD_path)['seps'])
    RMLD_nonseps = list(sio.loadmat(RMLD_path)['nonseps'])
    RMLD_FEs = sio.loadmat(RMLD_path)['FEs'][0][0]
    groups = []
    if RMLD_seps != []:
        for group in RMLD_seps:
            groups.append([group[0]-1])
    if RMLD_nonseps != []:
        RMLD_nonseps = RMLD_nonseps[0]
        for group in RMLD_nonseps:
            t = list(group[0])
            for i in range(len(t)):
                t[i] -= 1
            groups.append(t)
    return groups, RMLD_FEs
