import numpy as np
import pandas as pd
import yaml

if __name__ == "__main__":

    with open(r'config/test.yaml') as file:
        data = yaml.load(file, Loader=yaml.FullLoader)
    
    s = pd.Series(data['data'])
    print(s)
    print(s.to_numpy())