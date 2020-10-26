package fai.plugin.vo.impl;

import fai.plugin.vo.IName;
import com.google.common.base.CaseFormat;
import com.intellij.database.model.DasColumn;
import lombok.Getter;

/**
 * Java字段名称对象
 *
 * @author HouKunLin
 * @date 2020/7/18 0018 2:41
 */
@Getter
public class FieldNameInfo implements IName {
    private final String value;
    private final String firstUpper;
    private final String firstLower;
    private final String underscoreUpper;

    public FieldNameInfo(String value, String firstUpper, String firstLower, String underscoreUpper) {
        this.value = value;
        this.firstUpper = firstUpper;
        this.firstLower = firstLower;
        this.underscoreUpper = underscoreUpper;
    }

    public FieldNameInfo(DasColumn dbColumn) {
        this.value = CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL, dbColumn.getName());
        this.firstUpper = CaseFormat.LOWER_CAMEL.to(CaseFormat.UPPER_CAMEL, value);
        this.firstLower = value;
        // UPPER_UNDERSCORE
        this.underscoreUpper = CaseFormat.LOWER_CAMEL.to(CaseFormat.UPPER_UNDERSCORE, dbColumn.getName());
    }

    @Override
    public String toString() {
        return value;
    }
}
