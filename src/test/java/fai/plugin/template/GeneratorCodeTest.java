package fai.plugin.template;

import org.junit.Test;

import java.io.File;

public class GeneratorCodeTest {

    @Test
    public void getFileType() {
        TplType tplType = TplType
                .create(new File("/Users/careinfress/workspace/plugin/fai-plugin-rcp-generator-idea/src/main/resources/templates/freemarker/faisco/"));

        System.out.println(tplType);
    }
}
