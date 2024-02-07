CREATE EXTERNAL TABLE IF NOT EXISTS `bigdataproj`.`ai_tweet_prediction` (
  `tweet` string,
  `screen_name` string,
  `followers_count` double,
  `location` string,
  `created_at` string,
  `sentiment_score` float,
  `sentiment_class` string,
  `label` double,
  `prediction` double
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES ('field.delim' = ',')
STORED AS INPUTFORMAT 'org.apache.hadoop.mapred.TextInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION 's3://weclouddatalab/AI_prediction/'
TBLPROPERTIES ('classification' = 'csv', "skip.header.line.count"="1");



## can not alter table in athena 

alter table ai_tweet_prediction add column crate_date date;

ALTER TABLE ai_tweet_prediction ADD COLUMN create_date VARCHAR(6);

INSERT INTO ai_tweet_prediction  (create_date) 
SELECT SUBSTRING(created_at, 4, 9) AS create_date
FROM ai_tweet_prediction;