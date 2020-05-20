# a file to find all the numbers not found in a list
import pandas
df = pandas.read_csv('jobs.csv')

# beggining of bash script
print(df['jobs'].max() + 1)