package com.xiongxin.app.typeHandles;

import com.xiongxin.app.domain.Example;
import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.MappedJdbcTypes;
import org.apache.ibatis.type.MappedTypes;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@MappedTypes(Example.class)
public class ExampleTypeHandles extends BaseTypeHandler<Example> {

    @Override
    public void setNonNullParameter(PreparedStatement ps, int i, Example parameter, JdbcType jdbcType) throws SQLException {
        ps.setString(i, parameter.getName());
    }

    @Override
    public Example getNullableResult(ResultSet rs, String columnName) throws SQLException {
        return new Example(rs.getString(columnName));
    }

    @Override
    public Example getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
        return  new Example(rs.getString(columnIndex));
    }

    @Override
    public Example getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
        return   new Example(cs.getString(columnIndex));
    }
}
