${gen.setType("sysKit")}
package ${entity.packages.sysKit};

import fai.app.*;
import fai.cli.*;
import fai.comm.util.*;
import fai.web.*;
import fai.web.inf.*;

@Kit(Kit.Type.SYS)
public class Sys${entity.name}Impl extends CorpKitImpl implements Sys${entity.name} {

    public int add${entity.name}(int aid, Param info) throws Exception {
        return add${entity.name}(aid, info, null);
    }

    public int add${entity.name}(int aid, Param info, Ref<Integer> idRef) throws Exception{
        int rt = Errno.OK;

        if (info == null || info.isEmpty()) {
            rt = Errno.ARGS_ERROR;
            App.logErr(rt, "add${entity.name} info is null err");
            return rt;
        }

        // 创建cli
        ${entity.name.cli} cli = createCli();

        rt = cli.add${entity.name}(aid, info, idRef);
            if (rt != Errno.OK) {
            App.logErr(rt, "add${entity.name}  error;aid=%s, info=%s;", aid, info);
            return rt;
        }

        Log.logStd("add${entity.name} success;aid=%s, info=%s;", aid, info);
        return rt;
    }

    public int set${entity.name}(int aid, int id, ParamUpdater updater) throws Exception {
        int rt = Errno.OK;
        if (aid < 1 || id < 1 || updater == null || updater.isEmpty()) {
            rt = Errno.ARGS_ERROR;
            App.logErr(rt, "args err;aid=%s, id=%s;", aid, id);
            return rt;
        }

        // 创建cli
        ${entity.name.cli} cli = createCli();

        rt = cli.set${entity.name}(aid, id, updater);
        if (rt != Errno.OK) {
            App.logErr(rt, "set${entity.name} error;aid=%s, id=%s;", aid, id);
            return rt;
        }

        Log.logStd("set${entity.name} success;aid=%s, id=%s;", aid, id);
        return rt;
    }

    public Param get${entity.name}(int aid, int id) throws Exception {
        int rt = Errno.OK;
        Param info = new Param();
        if (aid < 1 || id < 1) {
            return info;
        }

        // 创建cli
        ${entity.name.cli} cli = createCli();

        rt = cli.get${entity.name}(aid, id, info);
        if (rt != Errno.OK) {
            throw new WebException(rt, "get${entity.name} error");
        }

        // 如果不存在的时候
        if (info == null || info.isEmpty()) {
            return new Param();
        }

        return info;
    }

    public FaiList<Param> get${entity.name}List(int aid, SearchArg searchArg) throws Exception {
        int rt = Errno.OK;
        FaiList<Param> infoList = new FaiList<Param>();

        // 创建cli
        ${entity.name.cli} cli = createCli();

        rt = cli.get${entity.name}List(aid, searchArg, infoList);
        if (rt != Errno.OK && rt != Errno.NOT_FOUND) {
            throw new WebException(rt, "search error");
        }

        return infoList;

    }

    private ${entity.name.cli} createCli() throws Exception {
        ${entity.name.cli} cli = new ${entity.name.cli}(Core.getFlow());
            if (!cli.init()) {
            throw new WebException("${entity.name.cli} init error");
        }
        return cli;
    }
}
