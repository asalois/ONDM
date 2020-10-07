#!/bin/bash

echo "40% MPI compensation!"

listVar="MPI_Compensation_40_ls1_0_span_60_km MPI_Compensation_40_ls1_10_span_60_km MPI_Compensation_40_ls1_20_span_60_km MPI_Compensation_40_ls1_30_span_60_km MPI_Compensation_40_ls1_40_span_60_km MPI_Compensation_40_ls1_50_span_60_km MPI_Compensation_40_ls1_60_span_60_km"

j=0
for i in $listVar;do
#	  mkdir "$i"
	  cp -r *.m "$i"
	  cp -r benchmark_script_parallel.sh "$i"
	  cd "$i"
    sed -i "s/percComp = 0/percComp = 40/g" qsmf_simulation_fft2.m
	  let "j=j+10"
	  sed -i "s/segmentLength_1 = 0/segmentLength_1 = ${j}/g" qsmf_simulation_fft2.m
    sbatch benchmark_script_parallel.sh
    sleep 60
	  cd ..
done

echo "60% MPI compensation!"

listVar="MPI_Compensation_60_ls1_0_span_60_km MPI_Compensation_60_ls1_10_span_60_km MPI_Compensation_60_ls1_20_span_60_km MPI_Compensation_60_ls1_30_span_60_km MPI_Compensation_60_ls1_40_span_60_km MPI_Compensation_60_ls1_50_span_60_km MPI_Compensation_60_ls1_60_span_60_km"

j=0
for i in $listVar;do
#	  mkdir "$i"
	  cp -r *.m "$i"
	  cp -r benchmark_script_parallel.sh "$i"
	  cd "$i"
    sed -i "s/percComp = 0/percComp = 60/g" qsmf_simulation_fft2.m
	  let "j=j+10"
	  sed -i "s/segmentLength_1 = 0/segmentLength_1 = ${j}/g" qsmf_simulation_fft2.m
    sbatch benchmark_script_parallel.sh
    sleep 60
	  cd ..
done

echo "80% MPI compensation!"

listVar="MPI_Compensation_80_ls1_0_span_60_km MPI_Compensation_80_ls1_10_span_60_km MPI_Compensation_80_ls1_20_span_60_km MPI_Compensation_80_ls1_30_span_60_km MPI_Compensation_80_ls1_40_span_60_km MPI_Compensation_80_ls1_50_span_60_km MPI_Compensation_80_ls1_60_span_60_km"

j=0
for i in $listVar;do
#	  mkdir "$i"
	  cp -r *.m "$i"
	  cp -r benchmark_script_parallel.sh "$i"
	  cd "$i"
    sed -i "s/percComp = 0/percComp = 80/g" qsmf_simulation_fft2.m
	  let "j=j+10"
	  sed -i "s/segmentLength_1 = 0/segmentLength_1 = ${j}/g" qsmf_simulation_fft2.m
    sbatch benchmark_script_parallel.sh
    sleep 60
	  cd ..
done

echo "100% MPI compensation!"

listVar="MPI_Compensation_100_ls1_0_span_60_km MPI_Compensation_100_ls1_10_span_60_km MPI_Compensation_100_ls1_20_span_60_km MPI_Compensation_100_ls1_30_span_60_km MPI_Compensation_100_ls1_40_span_60_km MPI_Compensation_100_ls1_50_span_60_km MPI_Compensation_100_ls1_60_span_60_km"

j=0
for i in $listVar;do
#	  mkdir "$i"
	  cp -r *.m "$i"
	  cp -r benchmark_script_parallel.sh "$i"
	  cd "$i"
    sed -i "s/percComp = 0/percComp = 100/g" qsmf_simulation_fft2.m
	  let "j=j+10"
	  sed -i "s/segmentLength_1 = 0/segmentLength_1 = ${j}/g" qsmf_simulation_fft2.m
    sbatch benchmark_script_parallel.sh
    sleep 60
	  cd ..
done
