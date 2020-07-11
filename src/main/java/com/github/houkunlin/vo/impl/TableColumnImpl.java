package com.github.houkunlin.vo.impl;

import com.github.houkunlin.vo.ITableColumn;
import com.intellij.database.model.DasColumn;
import com.intellij.database.model.DataType;
import com.intellij.database.util.DasUtil;
import com.intellij.util.ReflectionUtil;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.apache.commons.lang.StringUtils;

/**
 * 数据库表字段信息（数据库表列对象信息）
 *
 * @author HouKunLin
 * @date 2020/5/28 0028 0:59
 */
@Getter
public class TableColumnImpl implements ITableColumn {
    /**
     * 数据库表的原始字段对象
     */
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private final DasColumn dbColumn;

    private final String name;
    private final String comment;
    private final String typeName;
    private final String fullTypeName;
    private final boolean primaryKey;
    @Setter
    private boolean selected;

    public TableColumnImpl(DasColumn dbColumn) {
        this.dbColumn = dbColumn;
        this.name = dbColumn.getName();
        DataType dataType = dbColumn.getDataType();
        this.fullTypeName = dataType.getSpecification();
        this.typeName = ReflectionUtil.getField(DataType.class, dataType, String.class, "typeName");
        this.comment = StringUtils.defaultString(dbColumn.getComment(), "");
        this.primaryKey = DasUtil.isPrimary(dbColumn);
        this.selected = true;
    }

}