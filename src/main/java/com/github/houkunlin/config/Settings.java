package com.github.houkunlin.config;

import lombok.Data;

/**
 * 设置信息
 *
 * @author HouKunLin
 * @date 2020/4/3 0003 14:56
 */
@Data
public class Settings {
    /**
     * 项目路径
     */
    private String projectPath;
    /**
     * Java代码路径
     */
    private String javaPath = "src/main/java";
    /**
     * 资源文件路径
     */
    private String sourcesPath = "src/main/resources";
    /**
     * Entity 后缀
     */
    private String entitySuffix = "Entity";
    /**
     * Dao 后缀
     */
    private String daoSuffix = "Repository";
    /**
     * Service 后缀
     */
    private String serviceSuffix = "Service";
    /**
     * Controller 后缀
     */
    private String controllerSuffix = "Controller";
    /**
     * Entity 包名
     */
    private String entityPackage = "com.example.entity";
    /**
     * Dao 包名
     */
    private String daoPackage = "com.example.repository";
    /**
     * Service 包名
     */
    private String servicePackage = "com.example.service";
    /**
     * Controller 包名
     */
    private String controllerPackage = "com.example.controller";
    /**
     * Mapper XML 包名
     */
    private String xmlPackage = "mapper";
    // -----------------------------------------这里开始是 fkw 的 rpc 配置-------------------------------
    /**
     * Cli 后缀
     */
    private String cliSuffix = "Cli";
    /**
     * cli 包名
     */
    private String cliPackage = "fai.cli";
    /**
     * Def 后缀
     */
    private String appSuffix = "Def";
    /**
     * Def 包名
     */
    private String appPackage = "fai.app";
    /**
     * Inf 包名
     */
    private String infPackage = "fai.web.inf";
    /**
     * Kit 包名
     */
    private String kitPackage = "fai.web.kit";

    /**
     * sysInf 包名
     */
    private String sysInfPackage = "fai.web.inf";

    /**
     * sysKit 包名
     */
    private String sysKitPackage = "fai.web.kit";

    /**
     * svr 后缀
     */
    private String svrSuffix = "Svr";
    /**
     * svr 包名
     */
    private String svrPackage = "fai.svr";

    /**
     * handler 后缀
     */
    private String handlerSuffix = "Handler";

    /**
     * Proc 后缀
     */
    private String procSuffix = "Proc";




    public String getSourcesPathAt(String filename) {
        return sourcesPath + "/" + filename;
    }

    public String getJavaPathAt(String filename) {
        return javaPath + "/" + filename;
    }
}
