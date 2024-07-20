import numpy as np
from Methods import RMLD
from os import path
from cec2013lsgo.cec2013 import Benchmark
from EAs.CC import CC_exe
from EAs.DE import DE_exe
import os
import warnings

warnings.filterwarnings('ignore')


if __name__ == "__main__":
    if os.path.exists('./RMLD_Data') == False:
        os.makedirs('./RMLD_Data')
    Dims = [1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 905, 905, 1000]

    bench = Benchmark()
    this_path = path.realpath(__file__)

    NIND = 100
    trial = 25

    for func_num in range(1, 16):
        Dim = Dims[func_num-1]
        FEs = 3000000
        func = bench.get_function(func_num)
        info = bench.get_info(func_num)
        scale = [info["lower"], info["upper"]]

        RMLD_obj_path = path.dirname(this_path) + "/RMLD_Data/f" + str(func_num) + ".csv"
        RMLD_groups, RMLD_FEs = RMLD(path.dirname(path.dirname(this_path)) + "/Groups/RMLD/f" + str(func_num) + ".mat")
        RMLD_MaxIter = int((FEs - RMLD_FEs) / Dim / NIND)
        print(RMLD_MaxIter)
        All_trial = []
        for i in range(trial):
            RMLD_obj = CC_exe(Dim, scale, NIND, RMLD_groups, RMLD_MaxIter, func, DE_exe)
            All_trial.append([RMLD_obj])
        np.savetxt("./RMLD_Data/F" + str(func_num) + ".csv", All_trial, delimiter=",")
