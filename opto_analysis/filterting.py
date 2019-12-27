def get_first_event(df, event_col="timepoint_s", threshold=25):
    return df.assign(diff_=df[event_col].diff()).pipe(lambda x: x[x.diff_ > threshold])[
        event_col
    ]


def get_last_event(df, event_col="timepoint_s", threshold=25):
    return (
        df.assign(shift_=df[event_col].shift(-1))
        .pipe(lambda x: x.assign(diff_=x["shift_"].diff()))
        .pipe(lambda x: x[x.diff_ > threshold])[event_col]
    )
