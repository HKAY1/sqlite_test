# test_app

A new Flutter project.

# TODO 

Proof of Concept for syncing data with global Database from Local App Database using custom made service

# Requirements

1. SQFLite dependency for Local Db 
2. internet_connectivity_plus dependency for Internet connection Status

# WorkFlow

Step 1 -> Define Local Db with two tables one will keep our local data and other one will hold our synced data.Both tables we have same feilds to avoid any kind of data conflict.

Table one will have an extra feild of type boolean namely isSynced which will indicate whether the data from our local db is synced with the global db or not.

(Note: We are not using any Global data base like FireStore, In this POC we will sync data from one table to another table while internet is connected.)

Step 2 -> Create model classes for both tables.

Step 3 -> Create a service in which we will initialize our local db and create both the tables mentioned earlier.

Step 4 -> Define functions for CRUD operations for table 1 and create function for table 2.

Step 5 -> Create UI for all the CRUD operations in table 1.

Step 6 -> Create a service which will constantly checks the internet connectivity.

Step 7 -> Implement all the functionality in the provider and call a Consumer on the UI for listening the provider.

Step 8 -> In Internet connectivity service if internet is available Spawn an Isolate to update tables in db and reflect them on ui.

# Status --> Success 