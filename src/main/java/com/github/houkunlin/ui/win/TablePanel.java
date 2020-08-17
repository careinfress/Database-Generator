package com.github.houkunlin.ui.win;

import com.github.houkunlin.model.JTableModel;
import com.github.houkunlin.vo.impl.EntityImpl;
import com.github.houkunlin.vo.impl.RootModel;
import com.intellij.database.psi.DbTable;
import lombok.Data;
import org.apache.commons.lang.StringUtils;

import javax.swing.*;

/**
 * 数据库表面板（对应了单个表的配置信息）
 *
 * @author HouKunLin
 * @date 2020/8/15 0015 16:09
 */
@Data
public class TablePanel implements IWindows {
    /**
     * 数据库表对象
     */
    private final DbTable dbTable;
    /**
     * 面板：顶级内容面板
     */
    private JPanel content;
    /**
     * 输入框：数据库表名
     */
    private JTextField tableNameField;
    /**
     * 输入框：Entity 名称
     */
    private JTextField entityNameField;
    /**
     * 输入框：Entity 注释
     */
    private JTextField commentField;
    /**
     * 表格：数据库表的字段信息
     */
    private JTable table1;
    /**
     * 界面表格对象的数据模型
     */
    private JTableModel model;
    /**
     * 生成代码时需要用到的model对象
     */
    private RootModel rootModel;

    public TablePanel(DbTable dbTable) {
        this.dbTable = dbTable;

        model = new JTableModel(table1, dbTable);
        toModel();
    }

    public RootModel toModel() {
        if (rootModel == null) {
            rootModel = new RootModel(dbTable, model.getFieldImpls(), model.getColumnImpls());
            tableNameField.setText(rootModel.getTable().getName());
            entityNameField.setText(String.valueOf(rootModel.getEntity().getName()));
            commentField.setText(rootModel.getTable().getComment());
            return rootModel;
        }
        EntityImpl entity = rootModel.getEntity();
        entity.setName(entityNameField.getText());
        entity.setComment(StringUtils.defaultString(commentField.getText(), ""));
        return rootModel;
    }

    @Override
    public JPanel getContent() {
        return content;
    }
}