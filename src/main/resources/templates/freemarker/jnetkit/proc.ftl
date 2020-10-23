${gen.setType("svr")}
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
            try {
                rt = dao.insert(TABLE_NAME, param);
                if (rt != Errno.OK) {
                    Log.logErr(rt, "insert ${entity.name} err;flow=%d, aid=%d", flow, aid);
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


    public int set${entity.name}(FaiSession session, int aid, int flow, int id, ParamUpdater updater) throws IOException {
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
            try {
                rt = dao.insert(TABLE_NAME, param);
                if (rt != Errno.OK) {
                Log.logErr(rt, "insert ${entity.name} err;flow=%d, aid=%d", flow, aid);
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


    @Cmd(${entity.name.def}.Protocol.Cmd.DEL)
    @WrittenCmd
    public int del${entity.name}(final FaiSession session,
                                @ArgFlow final int flow，
                                @ArgBodyInteger(value = ${entity.name.def}.Protocol.Key.ID) Integer id)
    throws IOException {
        return m_${entity.name.firstLower}Proc.del${entity.name}(session, flow, id, updater);
    }


    @Cmd(${entity.name.def}.Protocol.Cmd.GET)
    public int get${entity.name}(final FaiSession session,
                                @ArgFlow final int flow，
                                @ArgBodyInteger(value = ${entity.name.def}.Protocol.Key.ID) Integer id)
    throws IOException {
        return m_${entity.name.firstLower}Proc.get${entity.name}(session, flow, id);
    }


    @Cmd(${entity.name.def}.Protocol.Cmd.GET_LIST)
    public int get${entity.name}List(final FaiSession session,
                                @ArgFlow final int flow,
                                @ArgSearchArg(${entity.name.def}.Protocol.Key.SEARCH_ARG) SearchArg searchArg)
    throws IOException {
        return m_${entity.name.firstLower}Proc.get${entity.name}List(session, flow, searchArg);
    }


    private static final String TABLE_NAME = ${table.name};

    private DaoPool m_daoPool;
    private ServerConfig m_config;
    private RedisCacheManager m_cache;
    private PosReadWriteLock m_lock;

}