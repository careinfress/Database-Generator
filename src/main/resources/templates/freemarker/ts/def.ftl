${gen.setType("def")}
package ${entity.packages.def};

import fai.comm.util.*;

/**
 *
 * @author ${developer.author}
 * @date ${date.toString("yyyy-MM-dd HH:mm:ss")}
 */
public class ${entity.name.def} {
    public static final class Info {
    <#-- 循环类型及属性 -->
    <#list fields as field>
        <#if field.selected>
            public static final String ${field.name.underscoreUpper} = "${field.column.name}"; // ${field.typeName} ${field.comment}
        </#if>
    </#list>
    }

    // 控制前端返回的字段
    public static final class Field {
        public static final int GET = 1;        // 单个
        public static final int LIST = 2;       // 列表

        public static FaiList<String> getField(int type) {
            FaiList<String> keyList = new FaiList<String>();
            <#list fields as field>
                <#if field.selected>
                    keyList.add(Info.${field.name.underscoreUpper});
                </#if>
            </#list>
            if (type == GET) {

            }
            return keyList;
        }
    }

    public static final class Protocol {
        // 0-10不可用，内部预留
        public static final class Cmd {
            public static final int ADD = 11;
            public static final int DEL = 12;
            public static final int SET = 13;
            public static final int GET = 14;
            public static final int GET_LIST = 15;
        }

        public static final class Key {
            public static final int ID = 1;
            public static final int AID = 2;
            public static final int SID = 3;
            public static final int CID = 4;
            public static final int INFO = 5;
            public static final int INFO_LIST = 6;
            public static final int UPDATER = 7;
            public static final int SEARCH_ARG = 8;
            public static final int TOTAL_SIZE = 9;
            public static final int FIELD = 10;
        }

        public static final class Def {
            public static final int ${entity.name.def.underscoreUpper} = 1;
        }

        // 内部类静态代码块初始化def
        private static ParamDef g_${entity.name.def.firstLower} = new ParamDef();

        public static ParamDef getParamDef(int def) {
            switch (def) {
                case Def.${entity.name.def.underscoreUpper}:
                    return g_${entity.name.def.firstLower};
            }
            return new ParamDef();
        }

        static {
            TsMisc.setDef(Info.class, g_${entity.name.def.firstLower});
        }
    }
}