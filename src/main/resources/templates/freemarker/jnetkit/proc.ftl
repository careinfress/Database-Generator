${gen.setFilename("${entity.name}" + "Proc.java")}
${gen.setFilepath("fai.svr." + "${entity.name.svr}" + ".proc")}
package ${entity.packages.svr};

import fai.app.*;
import fai.comm.cache.redis.*;
import fai.comm.cache.redis.config.*;
import fai.comm.jnetkit.server.fai.*;

import fai.comm.util.*;
import java.io.*;
import java.util.*;
import java.io.IOException;

/**
 *
 * @author ${developer.author}
 * @date ${date.toString("yyyy-MM-dd HH:mm:ss")}
 */
public class ${entity.name}Proc {

    public ${entity.name}Proc(DaoPool daoPool, RedisCacheManager cache, PosReadWriteLock lock) {
        m_daoPool = daoPool;
        m_lock = lock;
        m_cache = cache;
    }

    public int add${entity.name}(FaiSession session, int aid, int flow, Param param) throws IOException {
        int rt = Errno.ERROR;
        Oss.SvrStat stat = new Oss.SvrStat(flow);
        // 获取数据库连接
        Dao dao = m_daoPool.getDao();
        if (dao == null) {
            rt = Errno.DAO_CONN_ERROR;
            Log.logErr(rt,"dao null err; flow=%d, aid=%d", flow, aid);
            return rt;
        }
        // 加锁语句要在 try 代码块之前
        m_lock.writeLock(aid);
        try {
            // TODO 这里省略较多跟业务相关代码，请自行填充

            Ref<Integer> rowCount = new Ref<Integer>();
            try {
                rt = dao.insert(TABLE_NAME, param, rowCount);
                if (rt != Errno.OK) {
                    Log.logErr(rt, "insert ${entity.name} err;flow=%d, aid=%d", flow, aid);
                    return rt;
                }
            } finally {
                dao.close();
            }
            rt = Errno.OK;
            // 回写客户端
            FaiBuffer sendBuf = new FaiBuffer(true);
            sendBuf.putInt(${entity.name.def}.Protocol.Key.ID, rowCount.value);
            session.write(sendBuf);
        } finally {
            m_lock.writeUnlock(aid);
            stat.end((rt != Errno.OK), rt);
        }
        return rt;
    }


    public int set${entity.name}(FaiSession session, int aid, int flow, int id, ParamUpdater updater) throws IOException {
        int rt = Errno.ERROR;
        Oss.SvrStat stat = new Oss.SvrStat(flow);
        if (id <= 0) {
            rt = Errno.ARGS_ERROR;
            Log.logErr(rt, "args error;flow=%d, aid=%d, id=%d", flow, aid, id);
            return rt;
        }
        Param updateInfo = updater.getData();
        // TODO 需要手动 assign
        Param data = new Param();

        // 获取数据库连接
        Dao dao = m_daoPool.getDao();
        if (dao == null) {
            rt = Errno.DAO_CONN_ERROR;
            Log.logErr(rt,"dao null err; flow=%d, aid=%d, id=%d", flow, aid, id);
            return rt;
        }
        // 加锁语句要在 try 代码块之前
        m_lock.writeLock(aid);
        try {
            // TODO 这里省略较多跟业务相关代码，请自行填充

            // TODO 手动 matcher 条件
            ParamMatcher matcher = new ParamMatcher();
            matcher.and(${entity.name.def}.${entity.name}Info.AID, ParamMatcher.EQ, aid);
            matcher.and(${entity.name.def}.${entity.name}Info.ID, ParamMatcher.EQ, id);
            ParamUpdater updater = new ParamUpdater(data);
            try {
                rt = dao.update(TABLE_NAME, updater, matcher);
                if (rt != Errno.OK) {
                    Log.logErr(rt, "update ${entity.name} err;flow=%d, aid=%d, id=%d", flow, aid, id);
                    return rt;
                }
            } finally {
                dao.close();
            }
            rt = Errno.OK;
            // rt != Errno.OK 时底层会自动 session.write(rt)
            // rt == Errno.OK 需要自行 session.write(rt)
            // 不要将 session.write(rt) 写进 finally 块中，否则服务端会出现 PIPE 问题
            session.write(rt);
        } finally {
            m_lock.writeUnlock(aid);
            stat.end((rt != Errno.OK), rt);
        }
        return rt;
    }


    public int del${entity.name}(FaiSession session, int aid, int flow, int id) throws IOException {
        int rt = Errno.ERROR;
        Oss.SvrStat stat = new Oss.SvrStat(flow);
        if (id <= 0) {
            rt = Errno.ARGS_ERROR;
            Log.logErr(rt, "args error;flow=%d, aid=%d, id=%d", flow, aid, id);
            return rt;
        }
        // 获取数据库连接
        Dao dao = m_daoPool.getDao();
        if (dao == null) {
            rt = Errno.DAO_CONN_ERROR;
            Log.logErr(rt,"dao null err; flow=%d, aid=%d", flow, aid);
            return rt;
        }
        // 加锁语句要在 try 代码块之前
        m_lock.writeLock(aid);
        try {
            // TODO 这里省略较多跟业务相关代码，请自行填充

            // TODO 手动 matcher 条件
            ParamMatcher matcher = new ParamMatcher();
            matcher.and(${entity.name.def}.${entity.name}Info.AID, ParamMatcher.EQ, aid);
            matcher.and(${entity.name.def}.${entity.name}Info.ID, ParamMatcher.EQ, id);
            try {
                rt = dao.delete(TABLE_NAME, matcher);
                if (rt != Errno.OK) {
                    Log.logErr(rt, "delete ${entity.name} err;flow=%d, aid=%d", flow, aid);
                    return rt;
                }
            } finally {
                dao.close();
            }
            rt = Errno.OK;
            // rt != Errno.OK 时底层会自动 session.write(rt)
            // rt == Errno.OK 需要自行 session.write(rt)
            // 不要将 session.write(rt) 写进 finally 块中，否则服务端会出现 PIPE 问题
            session.write(rt);
        } finally {
            m_lock.writeUnlock(aid);
            stat.end((rt != Errno.OK), rt);
        }
        return rt;
    }

    public int get${entity.name}(FaiSession session, int aid, int flow, int id) throws IOException {
        int rt = Errno.ERROR;
        Oss.SvrStat stat = new Oss.SvrStat(flow);
        if (id <= 0) {
            rt = Errno.ARGS_ERROR;
            Log.logErr(rt, "args error;flow=%d, aid=%d, id=%d", flow, aid, id);
            return rt;
        }
        // 获取数据库连接
        Dao dao = m_daoPool.getDao();
        if (dao == null) {
            rt = Errno.DAO_CONN_ERROR;
            Log.logErr(rt,"dao null err; flow=%d, aid=%d", flow, aid);
            return rt;
        }
        // 加锁语句要在 try 代码块之前
        m_lock.readLock(aid);
        try {
            // TODO 这里省略较多跟业务相关代码，请自行填充

            ParamMatcher matcher = new ParamMatcher();
            matcher.and(${entity.name.def}.${entity.name}Info.AID, ParamMatcher.EQ, aid);
            matcher.and(${entity.name.def}.${entity.name}Info.ID, ParamMatcher.EQ, id);
            SearchArg searchArg = new SearchArg();
            searchArg.matcher = matcher;
            Dao.SelectArg sltArg = new Dao.SelectArg();
            sltArg.table = TABLE_NAME;
            sltArg.searchArg = searchArg;
            Param info;
            try {
                info = dao.selectFirst(sltArg);
                if (null == info) {
                    Log.logErr(rt, "search ${entity.name} error;flow=%d, aid=%d, id=%d;", flow, aid, id);
                    return rt;
                }
            } finally {
                dao.close();
            }
            rt = Errno.OK;
            FaiBuffer sendBuf = new FaiBuffer(true);
            list.toBuffer(sendBuf, ${entity.name.def}.Protocol.Key.INFO, ${entity.name.def}.Protocol.get${entity.name.def}());
            session.write(sendBuf);
        } finally {
            m_lock.readLock(aid);
            stat.end((rt != Errno.OK && rt != Errno.NOT_FOUND), rt);
        }
        return rt;
    }

    public int get${entity.name}List(FaiSession session, int flow, SearchArg searchArg) throws IOException {
        int rt = Errno.ERROR;
        Oss.SvrStat stat = new Oss.SvrStat(flow);
        // 获取数据库连接
        Dao dao = m_daoPool.getDao();
        if (dao == null) {
            rt = Errno.DAO_CONN_ERROR;
            Log.logErr(rt,"dao null err; flow=%d, aid=%d", flow, aid);
            return rt;
        }
        // 加锁语句要在 try 代码块之前
        m_lock.readLock(aid);
        try {
            // TODO 这里省略较多跟业务相关代码，请自行填充

            Dao.SelectArg sltArg = new Dao.SelectArg();
            sltArg.table = TABLE_NAME;
            sltArg.searchArg = searchArg;
            FaiList<Param> list;
            try {
                list = dao.select(sltArg);
                if (null == list) {
                    Log.logErr(rt, "search ${entity.name}List error;flow=%d", flow);
                    return rt;
                }
            } finally {
                dao.close();
            }
            rt = Errno.OK;
            FaiBuffer sendBuf = new FaiBuffer(true);
            list.toBuffer(sendBuf, ${entity.name.def}.Protocol.Key.INFO, ${entity.name.def}.Protocol.get${entity.name.def}());
            if (searchArg.totalSize != null && searchArg.totalSize.value != null) {
                sendBuf.putInt(${entity.name.def}.Protocol.Key.TOTAL_SIZE, searchArg.totalSize.value);
            }
            session.write(sendBuf);
        } finally {
            m_lock.readLock(aid);
            stat.end((rt != Errno.OK && rt != Errno.NOT_FOUND), rt);
        }
        return rt;
    }


    protected static final String TABLE_NAME = ${table.name};

    private DaoPool m_daoPool;
    private RedisCacheManager m_cache;
    private PosReadWriteLock m_lock;

}