package com.github.houkunlin.vo.impl;

import com.github.houkunlin.config.Settings;
import lombok.Getter;
import org.apache.commons.lang.StringUtils;

import java.util.HashSet;
import java.util.stream.Collectors;

/**
 * 实体类对象的包信息
 *
 * @author HouKunLin
 * @date 2020/7/5 0005 15:12
 */
@Getter
public class EntityPackage {
    /**
     * 实体类字段所需要导入的包列表
     */
    private final HashSet<String> list = new HashSet<>();
    private String toString = "";
    /**
     * 实体类包名信息
     */
    private EntityPackageInfo entity;
    /**
     * Service 包名信息
     */
    private EntityPackageInfo service;
    /**
     * ServiceImpl 包名信息
     */
    private EntityPackageInfo serviceImpl;
    /**
     * Dao 包名信息
     */
    private EntityPackageInfo dao;
    /**
     * Controller 包名信息
     */
    private EntityPackageInfo controller;

    private EntityPackageInfo cli;

    private EntityPackageInfo def;

    private EntityPackageInfo inf;

    private EntityPackageInfo kit;

    private EntityPackageInfo sysInf;

    private EntityPackageInfo sysKit;

    private EntityPackageInfo svr;


    public void add(String fullPackageName) {
        if (fullPackageName.startsWith("java.lang.")) {
            return;
        }
        list.add(fullPackageName);
    }

    public void clear() {
        list.clear();
        toString = "";
    }

    @Override
    public String toString() {
        if (StringUtils.isBlank(toString)) {
            toString = list.stream().map(item -> String.format("import %s;\n", item)).collect(Collectors.joining());
        }
        return toString;
    }

    public void initMore(Settings settings, EntityName entityName) {
        this.entity = new EntityPackageInfo(settings.getEntityPackage(), entityName.getEntity());
        this.service = new EntityPackageInfo(settings.getServicePackage(), entityName.getService());
        this.serviceImpl = new EntityPackageInfo(settings.getServicePackage() + ".impl", entityName.getServiceImpl());
        this.dao = new EntityPackageInfo(settings.getDaoPackage(), entityName.getDao());
        this.controller = new EntityPackageInfo(settings.getControllerPackage(), entityName.getController());

        this.cli = new EntityPackageInfo(settings.getCliPackage(), entityName.getCli());
        this.def = new EntityPackageInfo(settings.getCliPackage(), entityName.getDef());
        this.inf = new EntityPackageInfo(settings.getInfPackage(), entityName.getInf());
        this.kit = new EntityPackageInfo(settings.getKitPackage(), entityName.getKit());
        this.sysInf = new EntityPackageInfo(settings.getSysInfPackage(), entityName.getSysInf());
        this.sysKit = new EntityPackageInfo(settings.getSysKitPackage(), entityName.getSysKit());

        this.svr = new EntityPackageInfo(settings.getSvrPackage(), entityName.getSvr());
    }
}
