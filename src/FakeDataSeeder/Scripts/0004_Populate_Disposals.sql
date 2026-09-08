use [DeliusRunningPictureDb];

IF NOT EXISTS (SELECT TOP (1) Id
               FROM DeliusRunningPicture.EventDetails)
    BEGIN

        insert into DeliusRunningPicture.EventDetails (OffenderId, Id, ReferralDate, ConvictionDate, Cohort, Deleted)
        select Id,
               row_number() over (order by OffenderId),
               CAST(DATEADD(month, 0 - Id, GETDATE()) as DATE),
               CAST(DATEADD(month, 1 + (0 - Id), GETDATE()) as DATE),
               '',
               0
        from DeliusRunningPicture.Offenders;
    END

IF NOT EXISTS (SELECT TOP (1) Id
               FROM DeliusRunningPicture.Disposal)
    BEGIN

        insert into DeliusRunningPicture.Disposal(OffenderId, Id, EventId, SentenceDate, Length, UnitCode,
                                                  UnitDescription, DisposalCode, DisposalDetail,
                                                  DisposalTerminationCode, DisposalTerminationDescription,
                                                  TerminationDate, Deleted)
        select ed.OffenderId,
               ed.Id,
               ed.Id,
               ed.ConvictionDate,
               10,
               'Y',
               'YEARS',
               'D1',
               'Details',
               null,
               null,
               null,
               0
        from DeliusRunningPicture.EventDetails as ed

    END
