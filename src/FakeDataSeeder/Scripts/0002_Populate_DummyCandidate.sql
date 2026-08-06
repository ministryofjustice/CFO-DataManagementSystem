USE ClusterDb;


PRINT 'Executing CreateDummyCandidate to populate dummy candidates...';

-- Check if the stored procedure exists before calling it (good practice for idempotency)
IF OBJECT_ID(N'[dbo].[CreateDummyCandidate]', N'P') IS NOT NULL
BEGIN
	exec CreateDummyCandidate '1FAK0001A','Alex','Apple','01/02/1990 00:00','A1001FK','F00001KE','TRUE','Female','British','Black','DELIUS','ACI','C06';
	exec CreateDummyCandidate '1FAK0002A','Sam','Sultana','08/05/1997 00:00','A1002FK','F00002KE','TRUE','Male','British','Asian','DELIUS','HII','N28';
	exec CreateDummyCandidate '1FAK0003A','Charlie','Cherry','24/03/1964 00:00','A1003FK','F00003KE','TRUE','Female','British','White','DELIUS','KMI','LCS';
	exec CreateDummyCandidate '1FAK0004A','Danny','Date','24/11/1956 00:00','A1004FK','F00004KE','TRUE','Male','British','Black','NOMIS','LPI','MRS';
	exec CreateDummyCandidate '1FAK0005A','Eddie','Elderberry','19/02/1984 00:00','A1005FK','F00005KE','FALSE','Female','British','Asian','NOMIS','MRI','MCG';
	exec CreateDummyCandidate '1FAK0006A','Vinay','Vegetable','01/01/1977 00:00','A1006FK','F00006KE','TRUE','Male','British','White','NOMIS','RSI','N50';
	exec CreateDummyCandidate '1FAK0007A','Gracie','Grape','08/04/1955 00:00','A1007FK','F00007KE','TRUE','Female','British','Black','NOMIS','PNI','CMB';
	exec CreateDummyCandidate '1FAK0008A','Harry','Honeydew','01/10/1982 00:00','A1008FK','F00008KE','TRUE','Male','British','Asian','NOMIS','BAI','C17';
	exec CreateDummyCandidate '1FAK0009A','Ivy','Icing','23/04/1985 00:00','A1009FK','F00009KE','TRUE','Female','British','White','DELIUS','BXI','LDN';
	exec CreateDummyCandidate '1FAK0010A','Paul','Papaya','18/12/1991 00:00','A1010FK','F00010KE','FALSE','Male','Bahamian','Black','DELIUS','FMI','N07';
	exec CreateDummyCandidate '1FAK0011A','Kelly','Kiwi','15/04/1976 00:00','A1011FK','F00011KE','TRUE','Female','British','Asian','NOMIS','ISI','N21';
	exec CreateDummyCandidate '1FAK0012A','Lenny','Lemon','26/05/1987 00:00','A1012FK','F00012KE','TRUE','Male','British','White','DELIUS','HLI','N55';
	exec CreateDummyCandidate '1FAK0013A','Mandy','Mango','25/01/2005 00:00','A1013FK','F00013KE','TRUE','Female','British','Black','DELIUS','HMI','HBS';
	exec CreateDummyCandidate '1FAK0014A','Andy','Apricot','23/03/2001 00:00','A1014FK','F00014KE','TRUE','Male','British','Asian','NOMIS','LEI','YSW';
	exec CreateDummyCandidate '1FAK0015A','Oscar','Orange','09/06/1977 00:00','A1015FK','F00015KE','FALSE','Female','British','White','NOMIS','NHI','C05';
	exec CreateDummyCandidate '1FAK0016A','Penny','Peach','25/04/1959 00:00','A1016FK','F00016KE','TRUE','Male','British','Black','NOMIS','LHI','C09';
	exec CreateDummyCandidate '1FAK0017A','Quincy','Quince','03/02/1971 00:00','A1017FK','F00017KE','TRUE','Female','British','Asian','DELIUS','BMI','N52';
	exec CreateDummyCandidate '1FAK0018A','Ryan','Raisin','12/02/1974 00:00','A1018FK','F00018KE','TRUE','Male','British','White','DELIUS','DGI','N30';
	exec CreateDummyCandidate '1FAK0019A','Sandy','Strawberry','20/06/2004 00:00','A1019FK','F00019KE','TRUE','Female','British','Black','NOMIS','DHI','SWM';
	exec CreateDummyCandidate '1FAK0020A','Tommy','Tangerine','24/01/1966 00:00','A1020FK','F00020KE','FALSE','Male','Bahamian','Asian','NOMIS','HEI','WMP';
	exec CreateDummyCandidate '1FAK0021A','Ursula','Ugli','04/09/1979 00:00','A1021FK','F00021KE','TRUE','Female','British','White','NOMIS','SFI','C11';
	exec CreateDummyCandidate '1FAK0022A','Carl','Cantaloupe','18/02/1974 00:00','A1022FK','F00022KE','TRUE','Male','British','Black','DELIUS','FHI','DBS';
	exec CreateDummyCandidate '1FAK0023A','Wally','Watermelon','20/11/1968 00:00','A1023FK','F00023KE','TRUE','Female','British','Asian','NOMIS','FWI','N31';
	exec CreateDummyCandidate '1FAK0024A','Xander','Ximenia','19/06/2006 00:00','A1024FK','F00024KE','TRUE','Male','British','White','NOMIS','LII','LNS';
	exec CreateDummyCandidate '1FAK0025A','Helen','Hazelnut','03/12/1962 00:00','A1025FK','F00025KE','FALSE','Female','British','Black','DELIUS','WLI','NSP';
	exec CreateDummyCandidate '1FAK0026A','Zack','Zucchini','08/11/1952 00:00','A1026FK','F00026KE','TRUE','Male','British','Asian','DELIUS','PBI','CBS';
	exec CreateDummyCandidate '1FAK0027A','Amy','Avocado','03/05/1999 00:00','A1027FK','F00027KE','TRUE','Female','British','White','NOMIS','NWI','N56';
	exec CreateDummyCandidate '1FAK0028A','Katharine','Kumquat','28/04/2004 00:00','A1028FK','F00028KE','TRUE','Male','British','Black','NOMIS','MTI','HFS';
	exec CreateDummyCandidate '1FAK0029A','Cathy','Coconut','09/07/1956 00:00','A1029FK','F00029KE','TRUE','Female','British','Asian','DELIUS','LNI','N02';
	exec CreateDummyCandidate '1FAK0030A','Dexter','Durian','27/11/1979 00:00','A1030FK','F00030KE','FALSE','Male','Bahamian','White','DELIUS','NLI','NBR';
	exec CreateDummyCandidate '1FAK0031A','Ellie','Endive','12/03/1973 00:00','A1031FK','F00031KE','TRUE','Female','British','Black','NOMIS','KVI','N23';
	exec CreateDummyCandidate '1FAK0032A','Freddy','Fennel','22/04/1972 00:00','A1032FK','F00032KE','TRUE','Male','British','Asian','NOMIS','HHI','N32';
	exec CreateDummyCandidate '1FAK0033A','Gina','Ginger','22/12/1967 00:00','A1033FK','F00033KE','TRUE','Female','British','White','NOMIS','DMI','N54';
	exec CreateDummyCandidate '1FAK0034A','Hank','Habanero','20/02/1991 00:00','A1034FK','F00034KE','TRUE','Male','British','Black','DELIUS','SDI','SSP';
	exec CreateDummyCandidate '1FAK0035A','Ingrid','Iceberg','18/03/1990 00:00','A1035FK','F00035KE','FALSE','Female','British','Asian','DELIUS','SLI','N35';
	exec CreateDummyCandidate '1FAK0036A','Jerry','Jalapeno','06/04/1996 00:00','A1036FK','F00036KE','TRUE','Male','British','White','DELIUS','SPI','N37';
	exec CreateDummyCandidate '1FAK0037A','Kara','Kale','09/07/1979 00:00','A1037FK','F00037KE','TRUE','Female','British','Black','NOMIS','WHI','N59';
	exec CreateDummyCandidate '1FAK0038A','Leo','Lime','18/12/1990 00:00','A1038FK','F00038KE','TRUE','Male','British','Asian','NOMIS','CWI','C19';
	exec CreateDummyCandidate '1FAK0039A','Molly','Melon','11/11/1964 00:00','A1039FK','F00039KE','TRUE','Female','British','White','NOMIS','DAI','DCP';
	exec CreateDummyCandidate '1FAK0040A','Nate','Nutmeg','08/01/2003 00:00','A1040FK','F00040KE','FALSE','Male','Bahamian','Black','NOMIS','BLI','C15';
	exec CreateDummyCandidate '1FAK0041A','Ollie','Olive','26/01/2002 00:00','A1041FK','F00041KE','TRUE','Female','British','Asian','NOMIS','GMI','DRS';
	exec CreateDummyCandidate '1FAK0042A','Polly','Parsnip','09/07/1970 00:00','A1042FK','F00042KE','TRUE','Male','British','White','NOMIS','EWI','ASP';
END
ELSE
BEGIN
    PRINT 'Stored procedure [dbo].[CreateDummyCandidate] not found. Skipping call.';
END
