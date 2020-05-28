
import pandas as pd

# Read in outputs from MATLAB
df = pd.read_csv('qsmf_output.csv')

# Rearrange
df = df[[' laserPowerdBmArray',' segmentLength_1', 'QdB', ' percComp', ' fiberAeff_1', ' fiberAeff_2', ' fiberAlphadB_1', ' fiberAlphadB_2']]
df.columns = ['Laser Power (dBm)', 'Length of Segment 1 (Km)', 'Q (dB)','Compensation (%)', ' fiberAeff_1', ' fiberAeff_2', ' fiberAlphadB_1', ' fiberAlphadB_2']
df = df.sort_values(['Compensation (%)', 'Length of Segment 1 (Km)', 'Laser Power (dBm)'])
df.to_csv('qsmf_output.csv', index=False)

# Make subframes from compensation
comp =[frame for percComp, frame in df.groupby(by='Compensation (%)')]


