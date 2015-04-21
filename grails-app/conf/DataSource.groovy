dataSource {
    pooled = true
    driverClassName = "com.mysql.jdbc.Driver"
    dialect = "org.hibernate.dialect.MySQL5InnoDBDialect"
}
hibernate {
    cache.use_second_level_cache = true
    cache.use_query_cache = false
//    cache.region.factory_class = 'net.sf.ehcache.hibernate.EhCacheRegionFactory' // Hibernate 3
    cache.region.factory_class = 'org.hibernate.cache.ehcache.EhCacheRegionFactory' // Hibernate 4
    singleSession = true // configure OSIV singleSession mode
    flush.mode = 'manual' // OSIV session flush mode outside of transactional context
}

// environment specific settings
environments {
    development {
        dataSource {
            dbCreate = "update" // one of 'create', 'create-drop','update'
            url = "jdbc:mysql://localhost/esicc?useUnicode=yes&characterEncoding=UTF-8"
            username = "root"
            password = ""
        }
        dataSource_erp {
            pooled = false
            driverClassName ="com.sybase.jdbc4.jdbc.SybDriver"
            username = "sa"
            password = ""
            dialect = org.hibernate.dialect.SybaseDialect
            dbCreate = "update" // one of 'create', 'create-drop', 'update', 'validate', ''
            url = "jdbc:sybase:Tds:192.168.2.100:5000/PYS"
        }

    }
    test {
        dataSource {
            dbCreate = "update"
            url = "jdbc:h2:mem:testDb;MVCC=TRUE;LOCK_TIMEOUT=10000;DB_CLOSE_ON_EXIT=FALSE"
        }
    }
    production {
        dataSource {
            pooled = true
            dbCreate = "update" // one of 'create', 'create-drop','update'
            url = "jdbc:mysql://localhost/esicc?useUnicode=yes&characterEncoding=UTF-8"
            username = "root"
            password = "eldia2k"
            properties {
                validationQuery="select 1"
                testWhileIdle=true
                timeBetweenEvictionRunsMillis=60000

            }
        }
        dataSource_erp {
            pooled = false
            driverClassName ="com.sybase.jdbc4.jdbc.SybDriver"
            username = "sa"
            password = ""
            dialect = org.hibernate.dialect.SybaseDialect
            dbCreate = "update" // one of 'create', 'create-drop', 'update', 'validate', ''
            url = "jdbc:sybase:Tds:192.168.2.100:5000/PYS"
        }
    }
}
