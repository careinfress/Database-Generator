package fai.plugin.template;

import com.google.common.base.CaseFormat;
import org.junit.Test;

public class FreeMarkerTest {

    @Test
    public void testGeneratorCli() {
        System.out.println("aaaa");
    }

    @Test
    public void testGenCode() {
        String aa = "upperUnderscore";
        String str = CaseFormat.LOWER_CAMEL.to(CaseFormat.UPPER_UNDERSCORE, aa);
        System.out.println(str);
        System.out.println(toDefName(aa));
    }


    public static String toDefName(String name) {
        StringBuilder result = new StringBuilder();
        // 从第一个字母
        if (name != null && name.length() != 0) {
            char firstChar = name.charAt(0);
            for (int i = 0, length = name.length(); i < length; i++) {
                char ch = name.charAt(i);
                // 第二个字母开始，遇到大写前面加下划线
                if (i > 0 && Character.isUpperCase(ch)) {
                    result.append("_" + ch);
                } else {
                    result.append(ch);
                }
            }
        }
        return result.toString().toUpperCase();
    }
}
