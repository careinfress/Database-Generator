${gen.setType("proc")}
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
public class ${entity.name.proc} {

    public ${entity.name.proc}(DaoPool daoPool, RedisCacheManager cache, PosReadWriteLock lock) {
        m_daoPool = daoPool;
        m_cache = cache;
        m_lock = lock;
    }

    public int add${entity.name}(FaiSession session, int aid, int flow, Param param) throws IOException {
        int rt = Errno.ERROR;
        Oss.SvrStat stat = new Oss.SvrStat(flow);
        try {
            // TODO 这里省略较多跟业务相关代码，请自行填充

            // 获取数据库连接
            Dao dao = m_daoPool.getDao();
            if (dao == null) {
                rt = Errno.DAO_CONN_ERROR;
                Log.logErr(rt,"dao null err; flow=%d, aid=%d", flow, aid);
                return rt;
            }

            Ref<Integer> rowCount = new Ref<Integer>();
            // 加锁语句要在 try 代码块之前
            m_lock.writeLock(aid);
            try {
                rt = dao.insert(TABLE_NAME, param, rowCount);
                if (rt != Errno.OK) {
                    Log.logErr(rt, "insert ${entity.name} err;flow=%d, aid=%d", flow, aid);
                    return rt;
                }
            } finally {
                dao.close();
                m_lock.writeUnlock(aid);
            }
            rt = Errno.OK;
            // 回写客户端
            FaiBuffer sendBuf = new FaiBuffer(true);
            sendBuf.putInt(${entity.name.def}.Protocol.Key.ID, rowCount.value);
            session.write(sendBuf);
        } finally {
            stat.end((rt != Errno.OK), rt);
        }
        return rt;
    }


    public int set${entity.name}(FaiSession session, int aid, int flow, int id, ParamUpdater updater) throws IOException {
        int rt = Errno.ERROR;
        Oss.SvrStat stat = new Oss.SvrStat(flow);
        try {
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

            // TODO 这里省略较多跟业务相关代码，请自行填充

            // 加锁语句要在 try 代码块之前
            m_lock.writeLock(aid);
            try {
                ParamMatcher matcher = new ParamMatcher();
                matcher.and(${entity.name.def}.${entity.name}Info.AID, ParamMatcher.EQ, aid);
                matcher.and(${entity.name.def}.${entity.name}Info.ID, ParamMatcher.EQ, id);
                ParamUpdater paramUpdater = new ParamUpdater(data);
                rt = dao.update(TABLE_NAME, paramUpdater, matcher);
                if (rt != Errno.OK) {
                    Log.logErr(rt, "update ${entity.name} err;flow=%d, aid=%d, id=%d", flow, aid, id);
                    return rt;
                }
            } finally {
                dao.close();
                m_lock.writeUnlock(aid);
            }
            rt = Errno.OK;
            // rt != Errno.OK 时底层会自动 session.write(rt)
            // rt == Errno.OK 需要自行 session.write(rt)
            // 不要将 session.write(rt) 写进 finally 块中，否则服务端会出现 PIPE 问题
            session.write(rt);
        } finally {
            stat.end((rt != Errno.OK), rt);
        }
        return rt;
    }


    public int del${entity.name}(FaiSession session, int aid, int flow, int id) throws IOException {
        int rt = Errno.ERROR;
        Oss.SvrStat stat = new Oss.SvrStat(flow);
        try {
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
            // TODO 这里省略较多跟业务相关代码，请自行填充

            // 加锁语句要在 try 代码块之前
            m_lock.writeLock(aid);
            try {
                ParamMatcher matcher = new ParamMatcher();
                matcher.and(${entity.name.def}.${entity.name}Info.AID, ParamMatcher.EQ, aid);
                matcher.and(${entity.name.def}.${entity.name}Info.ID, ParamMatcher.EQ, id);
                rt = dao.delete(TABLE_NAME, matcher);
                if (rt != Errno.OK) {
                    Log.logErr(rt, "delete ${entity.name} err;flow=%d, aid=%d", flow, aid);
                    return rt;
                }
            } finally {
                dao.close();
                m_lock.writeUnlock(aid);
            }
            rt = Errno.OK;
            // rt != Errno.OK 时底层会自动 session.write(rt)
            // rt == Errno.OK 需要自行 session.write(rt)
            // 不要将 session.write(rt) 写进 finally 块中，否则服务端会出现 PIPE 问题
            session.write(rt);
        } finally {
            stat.end((rt != Errno.OK), rt);
        }
        return rt;
    }

    public int get${entity.name}(FaiSession session, int aid, int flow, int id) throws IOException {
        int rt = Errno.ERROR;
        Oss.SvrStat stat = new Oss.SvrStat(flow);
        try {
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
            // TODO 这里省略较多跟业务相关代码，请自行填充

            Param info;
            // 加锁语句要在 try 代码块之前
            m_lock.readLock(aid);
            try {
                ParamMatcher matcher = new ParamMatcher();
                matcher.and(${entity.name.def}.${entity.name}Info.AID, ParamMatcher.EQ, aid);
                matcher.and(${entity.name.def}.${entity.name}Info.ID, ParamMatcher.EQ, id);
                SearchArg searchArg = new SearchArg();
                searchArg.matcher = matcher;

                Dao.SelectArg sltArg = new Dao.SelectArg();
                sltArg.table = TABLE_NAME;
                sltArg.searchArg = searchArg;
                info = dao.selectFirst(sltArg);
                if (null == info) {
                    Log.logErr(rt, "search ${entity.name} error;flow=%d, aid=%d, id=%d;", flow, aid, id);
                    return rt;
                }
            } finally {
                dao.close();
                m_lock.readLock(aid);
            }
            rt = Errno.OK;
            FaiBuffer sendBuf = new FaiBuffer(true);
            info.toBuffer(sendBuf, ${entity.name.def}.Protocol.Key.INFO, ${entity.name.def}.Protocol.get${entity.name.def}());
            session.write(sendBuf);
        } finally {
            stat.end((rt != Errno.OK && rt != Errno.NOT_FOUND), rt);
        }
        return rt;
    }

    public int get${entity.name}List(FaiSession session, int aid, int flow, SearchArg searchArg) throws IOException {
        int rt = Errno.ERROR;
        Oss.SvrStat stat = new Oss.SvrStat(flow);
        try {
            // 获取数据库连接
            Dao dao = m_daoPool.getDao();
            if (dao == null) {
                rt = Errno.DAO_CONN_ERROR;
                Log.logErr(rt,"dao null err; flow=%d", flow);
                return rt;
            }
            // TODO 这里省略较多跟业务相关代码，请自行填充

            FaiList<Param> list;
            // 加锁语句要在 try 代码块之前
            m_lock.readLock(aid);
            try {
                Dao.SelectArg sltArg = new Dao.SelectArg();
                sltArg.table = TABLE_NAME;
                sltArg.searchArg = searchArg;
                list = dao.select(sltArg);
                if (null == list) {
                    Log.logErr(rt, "search ${entity.name}List error;flow=%d", flow);
                    return rt;
                }
            } finally {
                dao.close();
                m_lock.readLock(aid);
            }
            rt = Errno.OK;
            FaiBuffer sendBuf = new FaiBuffer(true);
            list.toBuffer(sendBuf, ${entity.name.def}.Protocol.Key.INFO_LIST, ${entity.name.def}.Protocol.get${entity.name.def}());
            if (searchArg.totalSize != null && searchArg.totalSize.value != null) {
                sendBuf.putInt(${entity.name.def}.Protocol.Key.TOTAL_SIZE, searchArg.totalSize.value);
            }
            session.write(sendBuf);
        } finally {
            stat.end((rt != Errno.OK && rt != Errno.NOT_FOUND), rt);
        }
        return rt;
    }


    protected static final String TABLE_NAME = "${table.name}";

    private DaoPool m_daoPool;
    private RedisCacheManager m_cache;
    private PosReadWriteLock m_lock;

}