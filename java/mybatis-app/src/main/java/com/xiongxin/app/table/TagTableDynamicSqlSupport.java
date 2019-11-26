package com.xiongxin.app.table;

import org.mybatis.dynamic.sql.SqlColumn;
import org.mybatis.dynamic.sql.SqlTable;

import java.sql.Date;
import java.sql.JDBCType;

public class TagTableDynamicSqlSupport {
    public static final TagTable tagTable = new TagTable();
    public static final SqlColumn<Integer> id = tagTable.id;
    public static final SqlColumn<String> name = tagTable.name;
    public static final SqlColumn<Integer> pid = tagTable.pid;
    public static final SqlColumn<Date> created = tagTable.created;
    public static final SqlColumn<Date> updated = tagTable.updated;


    public static final class TagTable extends SqlTable {



        public final SqlColumn<Integer> id = column("id", JDBCType.INTEGER);
        public final SqlColumn<String> name = column("name", JDBCType.VARCHAR);
        public final SqlColumn<Integer> pid = column("pid", JDBCType.INTEGER);
        public final SqlColumn<Date> created = column("created", JDBCType.TIMESTAMP);
        public final SqlColumn<Date> updated = column("updated", JDBCType.TIMESTAMP);

        protected TagTable() {
            super("tag");
        }
    }
}
