package fai.svr.${className}Svr;

import fai.app.*;
import fai.comm.cache.redis.*;
import fai.comm.jnetkit.server.fai.*;
import fai.comm.util.*;
import java.io.*;
import java.util.*;

public class ${className}Proc {

    private String getCacheKey(int aid) {
        // todo 只供参考
        return TsRedisKeyDef.getRedisKey(TsRedisKeyDef.Key.${rediskeyName}, aid);
    }

    private DaoPool m_daoPool;
    private PosReadWriteLock m_lock;
    private RedisCacheManager m_rdsCache;
    private static final ParamDef PARAM_DEF = ${className}Def.Protocol.getParamDef(${className}Def.Protocol.Def.${defName});
    protected static final String TABLE_NAME = "${tableName}";

    public ${className}Proc(DaoPool daoPool, RedisCacheManager rdsCache, PosReadWriteLock lock) {
        m_daoPool = daoPool;
        m_rdsCache = rdsCache;
        m_lock = lock;
    }

    public int processAdd(FaiSession session) throws IOException {
        int rt = Errno.ERROR;
        int flow = session.getFlow();
        int aid = session.getAid();
        Oss.SvrStat stat = new Oss.SvrStat(flow);

        try {
            FaiBuffer recvBody = session.body();
            if (aid < 1 || recvBody == null) {
                rt = Errno.ARGS_ERROR;
                Log.logErr(rt, "recv body=null;flow=%d, aid=%s, recvBody=%s;", flow, aid, recvBody);
                return rt;
            }

            // recv info
            Ref<Integer> keyRef = new Ref<Integer>();
            Param recvInfo = new Param();
            rt = recvInfo.fromBuffer(recvBody, keyRef, PARAM_DEF);
            if (rt != Errno.OK || keyRef.value != ${className}Def.Protocol.Key.INFO) {
                rt = Errno.ARGS_ERROR;
                Log.logErr(rt, "info=null;flow=%d, aid=%s;", flow, aid);
                return rt;
            }

            int id = 0;

            // todo 需要手动改动,改为删掉注释
            Param data = new Param();

            Dao dao = m_daoPool.getDao();
            if (dao == null) {
                rt = Errno.DAO_CONN_ERROR;
                Log.logErr(rt, "dao err;flow=%d, aid=%s;", flow, aid);
                return rt;
            }

            try {
                m_lock.writeLock(aid);

                // oldInfo获取的数据
                Param oldInfo = null;
                Dao.SelectArg sltArg = new Dao.SelectArg();
                sltArg.searchArg.matcher = new ParamMatcher(${className}Def.Info.AID, ParamMatcher.EQ, aid);
                sltArg.table = TABLE_NAME;
                oldInfo = dao.selectFirst(sltArg);
                if (oldInfo == null) {
                    rt = Errno.DAO_SQL_ERROR;
                    Log.logErr(rt, "dao sql error;flow=%d, aid=%s,", flow, aid);
                    return rt;
                }

                // 判断是否重复
                if (!oldInfo.isEmpty()) {
                    rt = Errno.ALREADY_EXISTED;
                    Log.logErr(rt, "aid existed error;flow=%d, aid=%s;", flow, aid);
                    return rt;
                }

                // insert
                rt = dao.insert(TABLE_NAME, data);
                if (rt != Errno.OK) {
                    Log.logErr(rt, "db err;flow=%d, aid=%s, id=%s;", flow, aid, id);
                    return rt;
                }
            } finally {
                try {
                    // 判断是否存在当前aid的缓存
                    if (rt == Errno.OK && m_rdsCache.exists(getCacheKey(aid))) {
                        Dao.SelectArg sltArg = new Dao.SelectArg();
                        // 重新读取数据库的数据，存入缓存
                        sltArg.searchArg.matcher = new ParamMatcher(${className}Def.Info.AID, ParamMatcher.EQ, aid);
                        sltArg.table = TABLE_NAME;
                        Param dataInfo = dao.selectFirst(sltArg);
                        if (dataInfo != null) {
                            // 存入缓存
                            m_rdsCache.hsetParam(getCacheKey(aid), id + "", dataInfo, ${className}Def.Protocol.Key.INFO_LIST, PARAM_DEF);
                        }
                    }
                } finally {
                    dao.close();
                }
                m_lock.writeUnlock(aid);
            }

            rt = Errno.OK;
            Log.logStd(rt, "add ok;flow=%d, aid=%s, id=%s;", flow, aid, id);
        } finally {
            session.write(rt);
            stat.end((rt != Errno.OK && rt != Errno.NOT_FOUND), rt);
        }
        return rt;
    }


    public int processSet(FaiSession session) throws IOException {
        int rt = Errno.ERROR;
        int flow = session.getFlow();
        int aid = session.getAid();
        Oss.SvrStat stat = new Oss.SvrStat(flow);

        try {
            FaiBuffer recvBody = session.body();
            if (aid < 1 || recvBody == null) {
                rt = Errno.ARGS_ERROR;
                Log.logErr(rt, "recv body=null;flow=%d, aid=%d, recvBody=%s;", flow, aid, recvBody);
                return rt;
            }

            Ref<Integer> keyRef = new Ref<Integer>();
            ParamUpdater recvUpdater = ParamUpdater.parseParamUpdater(recvBody, keyRef, PARAM_DEF);
            if (recvUpdater == null || keyRef.value != ${className}Def.Protocol.Key.UPDATER) {
                rt = Errno.ARGS_ERROR;
                Log.logErr(rt, "updater=null;flow=%d, aid=%d;", flow, aid);
                return rt;
            }

            Ref<Integer> idRef = new Ref<Integer>();
            rt = recvBody.getInt(keyRef, idRef);
            if (rt != Errno.OK || keyRef.value != ${className}Def.Protocol.Key.ID || idRef == null) {
                rt = Errno.ARGS_ERROR;
                Log.logErr(rt, "id=null;flow=%d, aid=%d, idRef=%s", flow, aid, idRef);
                return rt;
            }
            int id = idRef.value;
            if(id < 1) {
                rt = Errno.ARGS_ERROR;
                Log.logErr(rt, "id=null;flow=%d, aid=%d, id=%s", flow, aid, id);
                return rt;
            }

            // 获取数据
            Param recvInfo = recvUpdater.getData();

            // todo 需要手动改动,改完删掉注释
            Param data = new Param();


            Dao dao = m_daoPool.getDao();
            if (dao == null) {
                rt = Errno.DAO_CONN_ERROR;
                Log.logErr(rt, "dao err;flow=%d, aid=%d, id=%s;", flow, aid, id);
                return rt;
            }

            int lockKey = HdTool.getLockKey(aid, id);
            try {
                m_lock.writeLock(lockKey);

                Param oldInfo = null;
                Dao.SelectArg sltArg = new Dao.SelectArg();
                sltArg.searchArg.matcher = new ParamMatcher(${className}Def.Info.AID, ParamMatcher.EQ, aid);
                sltArg.searchArg.matcher.and(${className}Def.Info.ID, ParamMatcher.EQ, id);
                sltArg.searchArg.matcher.and(${className}Def.Info.DEL, ParamMatcher.EQ, 0);
                sltArg.table = TABLE_NAME;
                oldInfo = dao.selectFirst(sltArg);
                if (oldInfo == null) {
                    rt = Errno.DAO_SQL_ERROR;
                    Log.logErr(rt, "dao sql error;flow=%d, aid=%d, id=%s;", flow, aid, id);
                    return rt;
                }

                // 不存在
                if (oldInfo.isEmpty()) {
                    rt = Errno.NOT_FOUND;
                    Log.logErr(rt, "not found error;flow=%d, aid=%d, id=%d;", flow, aid, id);
                    return rt;
                }

                // 修改数据
                ParamMatcher matcher = new ParamMatcher(${className}Def.Info.AID, ParamMatcher.EQ, aid);
                matcher.and(${className}Def.Info.ID, ParamMatcher.EQ, id);
                matcher.and(${className}Def.Info.DEL, ParamMatcher.EQ, 0);
                ParamUpdater updater = new ParamUpdater(data);
                rt = dao.update(TABLE_NAME, updater, matcher);
                if (rt != Errno.OK) {
                    Log.logErr(rt, "db err;flow=%d, aid=%d, id=%d;", flow, aid, id);
                    return rt;
                }

                if (updater != null) {
                    // 修改缓存
                    m_rdsCache.hsetParam(getCacheKey(aid), id + "", updater, ${className}Def.Protocol.Key.INFO_LIST, PARAM_DEF);
                }
            } finally {
                dao.close();
                m_lock.writeUnlock(lockKey);
            }

            rt = Errno.OK;
            Log.logStd("ok;flow=%d, aid=%d, id=%s, updater=%s", flow, aid, id, recvUpdater.toJson());
        } finally {
            session.write(rt);
            stat.end(rt != Errno.OK, rt);
        }
        return rt;
    }

    public int processGet(FaiSession session) throws IOException {
        int rt = Errno.ERROR;
        int flow = session.getFlow();
        int aid = session.getAid();
        Oss.SvrStat stat = new Oss.SvrStat(flow);

        try {

            FaiBuffer recvBody = session.body();
            if (aid < 1 || recvBody == null) {
                rt = Errno.ARGS_ERROR;
                Log.logErr(rt, "recv body=null;flow=%d, aid=%d, recvBody=%s;", flow, aid, recvBody);
                return rt;
            }
            Ref<Integer> keyRef = new Ref<Integer>();
            Ref<Integer> idRef = new Ref<Integer>();
            rt = recvBody.getInt(keyRef, idRef);
            if (rt != Errno.OK || keyRef.value != ${className}Def.Protocol.Key.ID || idRef == null) {
                rt = Errno.ARGS_ERROR;
                Log.logErr(rt, "id=null;flow=%d, aid=%d, idRef=%s", flow, aid, idRef);
                return rt;
            }
            int id = idRef.value;
            if(id < 1) {
                rt = Errno.ARGS_ERROR;
                Log.logErr(rt, "id=null;flow=%d, aid=%d, id=%s", flow, aid, id);
                return rt;
            }

            String key = getCacheKey(aid);
            if (!m_rdsCache.exists(key)) {
                // 初始化数据
                initDataList(flow, aid);
            }

            // 从缓存拿数据
            Param info = m_rdsCache.hgetParam(key, id, ${className}Def.Protocol.Key.INFO_LIST, PARAM_DEF);
            if (info == null) {
                info = new Param();
            }

            // send info
            FaiBuffer sendBuf = new FaiBuffer(true);
            info.toBuffer(sendBuf, ${className}Def.Protocol.Key.INFO, PARAM_DEF);
            session.write(sendBuf);

            rt = Errno.OK;
            Log.logDbg(rt, "ok;flow=%d, aid=%d, id=%s;", flow, aid, id);
        } finally {
            stat.end((rt != Errno.OK && rt != Errno.NOT_FOUND), rt);
        }
        return rt;
    }

    public int processGetList(FaiSession session) throws IOException {
        int rt = Errno.ERROR;
        int flow = session.getFlow();
        int aid = session.getAid();
        Oss.SvrStat stat = new Oss.SvrStat(flow);

        try {
            FaiBuffer recvBody = session.body();
            if (aid < 1 || recvBody == null) {
                rt = Errno.ARGS_ERROR;
                Log.logErr(rt, "recv body=null;flow=%d, aid=%d;", flow, aid);
                return rt;
            }
            Ref<Integer> keyRef = new Ref<Integer>();
            SearchArg searchArg = SearchArg.parseSearchArg(recvBody, keyRef);
            if (searchArg == null || keyRef.value != ${className}Def.Protocol.Key.SEARCH_ARG) {
                rt = Errno.CODEC_ERROR;
                Log.logErr(rt, "decode search arg error;flow=%d, aid=%d;", flow, aid);
                return rt;
            }

            Ref<String> fieldRef = new Ref<String>();
            rt = recvBody.getString(keyRef, fieldRef);
            if (rt != Errno.OK || keyRef.value != ${className}Def.Protocol.Key.FIELD) {
                rt = Errno.ARGS_ERROR;
                Log.logErr(rt, "field=null, keyRef=%s, flow=%d;", keyRef.value, flow);
                return rt;
            }
            String field = fieldRef.value;

            FaiList<Param> list;
            // 需要用到field的时候才直接db
            if (field != null && !field.isEmpty()) {
                Dao dao = m_daoPool.getDao();
                if (dao == null) {
                    rt = Errno.DAO_CONN_ERROR;
                    Log.logErr(rt, "conn db err;flow=%d, aid=%d;", flow, aid);
                    return rt;
                }
                try {
                    Dao.SelectArg sltArg = new Dao.SelectArg();
                    sltArg.table = TABLE_NAME;
                    if (field != null && !field.isEmpty()) {
                        sltArg.field = field;
                    }
                    sltArg.searchArg = searchArg;
                    list = dao.select(sltArg);
                } finally {
                    dao.close();
                }
                if (list == null) {
                    rt = Errno.DAO_SQL_ERROR;
                    Log.logErr(rt, "search error;flow=%d, aid=%d;", flow, aid);
                    return rt;
                }
            } else {
                // 获取缓存数据
                String key = getCacheKey(aid);
                if (!m_rdsCache.exists(key)) {
                    // 初始化数据
                    initDataList(flow, aid);
                }
                list = m_rdsCache.hgetAllFaiList(key, ${className}Def.Protocol.Key.INFO_LIST, PARAM_DEF);
                // 根据条件搜索
                Searcher searcher = new Searcher(searchArg);
                list = searcher.getParamList(list);
                if (list == null) {
                    list = new FaiList<Param>();
                }
            }

            // send info
            FaiBuffer sendBuf = new FaiBuffer(true);
            list.toBuffer(sendBuf, ${className}Def.Protocol.Key.INFO_LIST, PARAM_DEF);
            if (searchArg.totalSize != null && searchArg.totalSize.value != null) {
            sendBuf.putInt(${className}Def.Protocol.Key.TOTAL_SIZE, searchArg.totalSize.value);
            }
            session.write(sendBuf);
            rt = Errno.OK;
            Log.logDbg(rt, "ok;flow=%d, aid=%d;", flow, aid);
        } finally {
            stat.end((rt != Errno.OK && rt != Errno.NOT_FOUND), rt);
        }
        return rt;
    }

    private int initDataList(int flow, int aid) {
        int rt = Errno.ERROR;
        FaiList<Param> list = null;
        Dao dao = m_daoPool.getDao();
        if (dao == null) {
            rt = Errno.DAO_CONN_ERROR;
            Log.logErr(rt, "conn db err;flow=%d, aid=%d;", flow, aid);
            return rt;
        }
        try {
            SearchArg searchArg = new SearchArg();
            searchArg.matcher = new ParamMatcher(${className}Def.Info.AID, ParamMatcher.EQ, aid);
            Dao.SelectArg sltArg = new Dao.SelectArg();
            sltArg.table = TABLE_NAME;
            sltArg.searchArg = searchArg;
            list = dao.select(sltArg);
        } finally {
            dao.close();
        }
        if (list == null) {
            rt = Errno.DAO_SQL_ERROR;
            Log.logErr(rt, "search error;flow=%d, aid=%d;", flow, aid);
            return rt;
        }
    
        // 存入缓存
        String key = getCacheKey(aid);
        m_rdsCache.hmsetFaiList(key, ${className}Def.Info.ID, Var.Type.INT, list, ${className}Def.Protocol.Key.INFO_LIST, PARAM_DEF);
        Log.logStd("initDataList success;flow=%d, aid=%d, size=%s;", flow, aid, list.size());
        rt = Errno.OK;
        return rt;
    }
}
