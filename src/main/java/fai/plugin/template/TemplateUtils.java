package fai.plugin.template;

import fai.plugin.template.beetl.BeetlUtils;
import fai.plugin.template.freemarker.FreemarkerUtils;
import fai.plugin.template.velocity.VelocityUtils;

import java.io.File;
import java.io.IOException;
import java.util.Map;

/**
 * 模板工具
 *
 * @author HouKunLin
 * @date 2020/5/28 0028 1:35
 */
public class TemplateUtils {
    private final VelocityUtils velocityUtils;
    private final FreemarkerUtils freemarkerUtils;
    private final BeetlUtils beetlUtils;

    public TemplateUtils(File templateRootPath) throws IOException {
        this.velocityUtils = new VelocityUtils(templateRootPath);
        this.freemarkerUtils = new FreemarkerUtils(templateRootPath);
        this.beetlUtils = new BeetlUtils(templateRootPath);
    }

    /**
     * 渲染模板
     *
     * @param templateFile 模板内容
     * @param model        变量信息
     * @return 渲染结果
     * @throws IOException IO异常
     */
    public String generatorToString(File templateFile, Map<String, Object> model) throws Exception {
        switch (TplType.create(templateFile)) {
            case BEETL:
                return beetlUtils.generatorToString(templateFile, model);
            case VELOCITY:
                return velocityUtils.generatorToString(templateFile, model);
            case FREEMARKER:
                return freemarkerUtils.generatorToString(templateFile, model);
            default:
        }
        return "";
    }

    /**
     * 渲染模板
     *
     * @param templateContent 模板内容
     * @param model           变量
     * @return 渲染结果
     * @throws IOException IO异常
     */
    public String generatorToString(String templateContent, Map<String, Object> model, TplType type) throws Exception {
        switch (type) {
            case BEETL:
                return beetlUtils.generatorToString(templateContent, model);
            case VELOCITY:
                return velocityUtils.generatorToString(templateContent, model);
            case FREEMARKER:
                return freemarkerUtils.generatorToString(templateContent, model);
            default:
        }
        return templateContent;
    }
}
