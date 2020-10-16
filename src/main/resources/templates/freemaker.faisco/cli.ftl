package fai.cli;

import fai.app.*;
import fai.comm.cli.*;
import fai.comm.util.*;

public class ${className}Cli extends TsClient {
    private static ParamDef PARAM_DEF = ${className}Def.Protocol.getParamDef(${className}Def.Protocol.Def.${defName});

    public ${className}Cli(int flow) {
        super(flow, "${className}Cli");
    }
    
    public boolean init() {
        return init("${className}Cli", true);
    }

    public int add${className}(int aid, Param info, Ref<Integer> idRef) {
        m_rt = Errno.ERROR;
        
        // 数据校验
        if (info == null || info.isEmpty()) {
            m_rt = Errno.ARGS_ERROR;
            Log.logErr(m_rt, "args error");
            return m_rt;
        }
        
        // send数据对象
        FaiBuffer sendBody = new FaiBuffer(true);
        info.toBuffer(sendBody, ${className}Def.Protocol.Key.INFO, PARAM_DEF);

        // 发包给svr
        m_rt = super.baseAddFun(${className}Def.Protocol.Cmd.ADD, sendBody, aid, TsViewerDef.Protocol.Key.ID, idRef);
        
        return m_rt;
    }

    // 修改
    public int set${className}(int aid, int id, ParamUpdater updater) {
        m_rt = Errno.ERROR;
        
        // 数据校验
        if (aid < 1 || id < 1 || updater == null || updater.isEmpty()) {
            m_rt = Errno.ARGS_ERROR;
            Log.logErr(m_rt, "args error;aid=%s, id=%s;", m_aid, id);
            return m_rt;
        }
        
        // send数据对象
        FaiBuffer sendBody = new FaiBuffer(true);
        updater.toBuffer(sendBody, ${className}Def.Protocol.Key.UPDATER, PARAM_DEF);
        sendBody.putInt(${className}Def.Protocol.Key.ID, id);
        
        // 发包给svr
        m_rt = super.baseSetFun(${className}Def.Protocol.Cmd.SET, sendBody, aid);
        
        return m_rt;
    }
        
    // 获取信息
    public int get${className}(int aid, int id, Param info) {
        m_rt = Errno.ERROR;
        
        // 数据校验
        if (aid < 1 || id < 1) {
            m_rt = Errno.ARGS_ERROR;
            Log.logErr(m_rt, "args error");
            return m_rt;
        }
    
        Ref<FaiBuffer> recvBodyRef = new Ref<FaiBuffer>();
    
        // send数据对象
        FaiBuffer sendBody = new FaiBuffer(true);
        sendBody.putInt(${className}Def.Protocol.Key.ID, id);

        // 发包给svr
        m_rt = super.baseGetFun(${className}Def.Protocol.Cmd.GET, sendBody, aid, recvBodyRef);
        if (m_rt != Errno.OK) {
            return m_rt;
        }

        // 把回包对象解析到info
        Ref<Param> infoRef = new Ref<Param>(info);
        int infoKey = ${className}Def.Protocol.Key.INFO;
        m_rt = super.unpackInfo(recvBodyRef.value, PARAM_DEF, infoKey, infoRef);

        return m_rt;
    }

    public int get${className}List(int aid, SearchArg searchArg, FaiList<Param> infoList) {
        return get${className}List(aid, searchArg, infoList, "");
    }
    
    // 获取列表
    public int get${className}List(int aid, SearchArg searchArg, FaiList<Param> infoList, String fieldStr) {
        m_rt = Errno.ERROR;
    
        // send数据对象
        FaiBuffer sendBody = new FaiBuffer(true);
        searchArg.toBuffer(sendBody, ${className}Def.Protocol.Key.SEARCH_ARG);
        sendBody.putString(${className}Def.Protocol.Key.FIELD, fieldStr);
    
        Ref<FaiBuffer> recvBodyRef = new Ref<FaiBuffer>();

        // 发包给svr
        m_rt = super.baseGetFun(${className}Def.Protocol.Cmd.GET_LIST, sendBody, aid, recvBodyRef);
        if (m_rt != Errno.OK) {
            return m_rt;
        }

        // 把回包对象解析到list
        Ref<FaiList<Param>> infoListRef = new Ref<FaiList<Param>>(infoList);
        int infoKey = ${className}Def.Protocol.Key.INFO_LIST;
        int totalKey = ${className}Def.Protocol.Key.TOTAL_SIZE;
        m_rt = super.unpackList(recvBodyRef.value, searchArg, PARAM_DEF, infoKey, totalKey, infoListRef);

        return m_rt;
    }
}
