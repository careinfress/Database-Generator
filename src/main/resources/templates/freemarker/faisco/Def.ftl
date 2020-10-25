${gen.setType("def")}
package ${entity.packages.def};

import fai.comm.util.*;


/**
 *
 * @author ${developer.author}
 * @date ${date.toString("yyyy-MM-dd HH:mm:ss")}
 */
public class ${entity.name.def} {

    public ${entity.name.def}() {
        throw new AssertionError();
    }

    public static final class ${entity.name}Info {
    <#list fields as field>
        <#if field.selected>
            public static final String ${field.name.underscoreUpper} = "${field.column.name}"; // ${field.typeName} ${field.comment}
        </#if>
    </#list>
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
                public static final int MATCHER = 8;
                public static final int SEARCH_ARG = 9;
                public static final int TOTAL_SIZE = 10;
                public static final int FIELD = 11;
            }
            private static ParamDef g_${entity.name.def.firstLower} = new ParamDef();
            static {
            <#list 0..(fields!?size-1) as i>
                <#if fields[i].selected>
                    g_${entity.name.def.firstLower}.add(${entity.name}Info.${fields[i].name.underscoreUpper}, ${i});
                </#if>
            </#list>
            }
            public static ParamDef get${entity.name.def}() {
                return g_${entity.name.def.firstLower};
            }
        }
}