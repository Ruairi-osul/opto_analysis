from pathlib import Path
from pyarrow.feather import write_feather
from spiketimes.simulate import imhomogenous_poisson_process, shuffled_isi_spiketrains
from spiketimes.df import list_to_df, spike_count_correlation_df_test

first_spiketrain = imhomogenous_poisson_process([(10, 5), (30, 2), (1800, 4)])
spiketrains = shuffled_isi_spiketrains(first_spiketrain, n=50)
df = list_to_df(spiketrains)

df_r = spike_count_correlation_df_test(
    df,
    fs=100,
    neuron_col="spiketrain",
    spiketimes_col="timepoint_s",
    min_firing_rate=1,
    verbose=True,
)

out_filename = Path(".").absolute().parent / "data" / "correlation_output.feather"
write_feather(df_r, str(out_filename))
