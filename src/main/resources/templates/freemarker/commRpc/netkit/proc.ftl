${gen.setType("proc")}
package ${entity.packages.svr};

import fai.app.*;
import fai.comm.cache.redis.*;
import fai.comm.cache.redis.config.*;
import fai.comm.netkit.FaiProtocol;

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

    public ${entity.name.proc}(DaoPool daoPool, RedisCacheManager cache, PosReadWriteLock lock, Param option) {
        m_daoPool = daoPool;
        m_lock = lock;
        m_cache = cache;
        m_svrOption = option;
    }

    public int processAdd(FaiProtocol recvProtocol, FaiProtocol sendProtocol) {
        int rt = Errno.ERROR;
        int flow = recvProtocol.getFlow();
        int aid = recvProtocol.getAid();
        Oss.SvrStat stat = new Oss.SvrStat(flow);
        try {
            // 解码
            FaiBuffer recvBody = recvProtocol.getDecodeBody();
            if (recvBody == null) {
                rt = Errno.ARGS_ERROR;
                Log.logErr(rt, "recv body null;flow=%d", flow);
                return rt;
            }

            Param recvInfo = new Param();
            Ref<Integer> keyRef = new Ref<Integer>();
            rt = recvInfo.fromBuffer(recvBody, keyRef, ${entity.name.def}.Protocol.get${entity.name.def}());
            if (rt != Errno.OK || keyRef.value != ${entity.name.def}.Protocol.Key.INFO) {
                rt = Errno.ARGS_ERROR;
                Log.logErr(rt, "args error;flow=%d", flow);
                return rt;
            }

            // TODO assign
            Param data = new Param();

            // TODO 这里省略较多跟业务相关代码，请自行填充

            // 获取数据库连接
            Dao dao = m_daoPool.getDao();
            if (dao == null) {
                rt = Errno.DAO_CONN_ERROR;
                Log.logErr(rt,"dao null err;flow=%d, aid=%d", flow, aid);
                return rt;
            }
            Ref<Integer> rowCount = new Ref<Integer>();
            // 加锁语句要在 try 代码块之前
            m_lock.writeLock(aid);
            try {
                // TODO 这里省略较多跟业务相关代码，请自行填充

                try {
                    rt = dao.insert(TABLE_NAME, data, rowCount);
                    if (rt != Errno.OK) {
                        Log.logErr(rt, "insert ${entity.name} err;flow=%d, aid=%d", flow, aid);
                        return rt;
                    }
                } finally {
                    dao.close();
                }
            } finally {
                m_lock.writeUnlock(aid);
            }
            // 回写客户端
            FaiBuffer sendBuf = new FaiBuffer(true);
            sendBuf.putInt(${entity.name.def}.Protocol.Key.ID, rowCount.value);
            sendProtocol.addEncodeBody(sendBuf);
            rt = Errno.OK;
            Log.logStd(rt, "insert ${entity.name} ok;flow=%d, aid=%d", flow, aid);
        } finally {
            stat.end((rt != Errno.OK), rt);
        }
        return rt;
    }


    public int processSet(FaiProtocol recvProtocol, FaiProtocol sendProtocol) {
        int rt = Errno.ERROR;
        int flow = recvProtocol.getFlow();
        int aid = recvProtocol.getAid();
        Oss.SvrStat stat = new Oss.SvrStat(flow);
        try {
            // 解码
            FaiBuffer recvBody = recvProtocol.getDecodeBody();
            if (recvBody == null) {
                rt = Errno.ARGS_ERROR;
                Log.logErr(rt, "recv body null; flow=%d", flow);
                return rt;
            }
            // 按照客户端 sendBody 的编码顺序解码传入参数
            Ref<Integer> keyRef = new Ref<Integer>();
            // 第一个参数 id
            Ref<Integer> idRef = new Ref<Integer>();
            rt = recvBody.getInt(keyRef, idRef);
            if (rt != Errno.OK || keyRef.value != ${entity.name.def}.Protocol.Key.ID) {
                rt = Errno.ARGS_ERROR;
                Log.logErr(rt, "recv codec err; flow=%d, aid=%d", flow, aid);
                return rt;
            }
            int id = idRef.value;
            if (id <= 0) {
                rt = Errno.ARGS_ERROR;
                Log.logErr(rt, "args error;flow=%d, aid=%d, id=%d", flow, aid, id);
                return rt;
            }
            // 第二个参数 ParamUpdater
            ParamUpdater recvUpdater = ParamUpdater.parseParamUpdater(recvBody, keyRef, ${entity.name.def}.Protocol.get${entity.name.def}());
            if (recvUpdater == null || keyRef.value != ${entity.name.def}.Protocol.Key.UPDATER) {
                rt = Errno.ARGS_ERROR;
                Log.logErr(rt, "args error;flow=%d, aid=%d", flow, aid);
                return rt;
            }
            // 获取数据
            Param recvInfo = recvUpdater.getData();
            // TODO assign
            Param data = new Param();

            // 获取数据库连接
            Dao dao = m_daoPool.getDao();
            if (dao == null) {
                rt = Errno.DAO_CONN_ERROR;
                Log.logErr(rt,"dao null err;flow=%d, aid=%d, id=%d", flow, aid, id);
                return rt;
            }

            // 加锁语句要在 try 代码块之前
            m_lock.writeLock(aid);
            try {
                // TODO 这里省略较多跟业务相关代码，请自行填充

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
                }
            } finally {
                m_lock.writeUnlock(aid);
            }
            rt = Errno.OK;
        } finally {
            stat.end((rt != Errno.OK), rt);
        }
        return rt;
    }


    public int processDel(FaiProtocol recvProtocol, FaiProtocol sendProtocol) {
        int rt = Errno.ERROR;
        int flow = recvProtocol.getFlow();
        int aid = recvProtocol.getAid();
        Oss.SvrStat stat = new Oss.SvrStat(flow);
        try {
            // 解码
            FaiBuffer recvBody = recvProtocol.getDecodeBody();
            if (recvBody == null) {
                rt = Errno.ARGS_ERROR;
                Log.logErr(rt, "recv body null; flow=%d", flow);
                return rt;
            }
            // 按照客户端 sendBody 的编码顺序解码传入参数
            Ref<Integer> keyRef = new Ref<Integer>();
            Ref<Integer> idRef = new Ref<Integer>();
            rt = recvBody.getInt(keyRef, idRef);
            if (rt != Errno.OK || keyRef.value != ${entity.name.def}.Protocol.Key.ID) {
                rt = Errno.ARGS_ERROR;
                Log.logErr(rt, "id=null;flow=%d, aid=%d, idRef=%s", flow, aid, idRef);
                return rt;
            }
            int id = idRef.value;
            if (id <= 0) {
                rt = Errno.ARGS_ERROR;
                Log.logErr(rt, "args error;flow=%d, aid=%d, id=%d", flow, aid, id);
                return rt;
            }
            // TODO 这里省略较多跟业务相关代码，请自行填充

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
                    // TODO 手动 matcher 条件
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
                }
            } finally {
                m_lock.writeUnlock(aid);
            }
            rt = Errno.OK;
        } finally {
            stat.end((rt != Errno.OK), rt);
        }
        return rt;
    }

    public int processGet(FaiProtocol recvProtocol, FaiProtocol sendProtocol) {
        int rt = Errno.ERROR;
        int flow = recvProtocol.getFlow();
        int aid = recvProtocol.getAid();
        Oss.SvrStat stat = new Oss.SvrStat(flow);
        try {
            // 解码
            FaiBuffer recvBody = recvProtocol.getDecodeBody();
            if (recvBody == null) {
                rt = Errno.ARGS_ERROR;
                Log.logErr(rt, "recv body null; flow=%d", flow);
                return rt;
            }
            // 按照客户端 sendBody 的编码顺序解码传入参数
            Ref<Integer> keyRef = new Ref<Integer>();
            Ref<Integer> idRef = new Ref<Integer>();
            rt = recvBody.getInt(keyRef, idRef);
            if (rt != Errno.OK || keyRef.value != ${entity.name.def}.Protocol.Key.ID) {
                rt = Errno.ARGS_ERROR;
                Log.logErr(rt, "id=null;flow=%d, aid=%d, idRef=%s", flow, aid, idRef);
                return rt;
            }
            int id = idRef.value;
            if (id <= 0) {
                rt = Errno.ARGS_ERROR;
                Log.logErr(rt, "args error;flow=%d, aid=%d, id=%d", flow, aid, id);
                return rt;
            }
            // TODO 这里省略较多跟业务相关代码，请自行填充

            // 获取数据库连接
            Dao dao = m_daoPool.getDao();
            if (dao == null) {
                rt = Errno.DAO_CONN_ERROR;
                Log.logErr(rt,"dao null err; flow=%d, aid=%d", flow, aid);
                return rt;
            }
            Param info;
            // 加锁语句要在 try 代码块之前
            m_lock.readLock(aid);
            try {
                // TODO 这里省略较多跟业务相关代码，请自行填充

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
                }
            } finally {
                m_lock.readUnlock(aid);
            }
            rt = Errno.OK;
            FaiBuffer sendBuf = new FaiBuffer(true);
            info.toBuffer(sendBuf, ${entity.name.def}.Protocol.Key.INFO, ${entity.name.def}.Protocol.get${entity.name.def}());
            sendProtocol.addEncodeBody(sendBuf);
        } finally {
            stat.end((rt != Errno.OK && rt != Errno.NOT_FOUND), rt);
        }
        return rt;
    }

    public int processGetLit(FaiProtocol recvProtocol, FaiProtocol sendProtocol) {
        int rt = Errno.ERROR;
        int flow = recvProtocol.getFlow();
        int aid = recvProtocol.getAid();
        Oss.SvrStat stat = new Oss.SvrStat(flow);
        try {
            // 解码
            FaiBuffer recvBody = recvProtocol.getDecodeBody();
            if (recvBody == null) {
                rt = Errno.ARGS_ERROR;
                Log.logErr(rt, "recv body null; flow=%d", flow);
                return rt;
            }
            Ref<Integer> keyRef = new Ref<Integer>();
            SearchArg searchArg = SearchArg.parseSearchArg(recvBody, keyRef);
            if (searchArg == null || keyRef.value != ${entity.name.def}.Protocol.Key.SEARCH_ARG) {
                rt = Errno.CODEC_ERROR;
                Log.logErr(rt, "decode search arg error;flow=%d, aid=%d", flow, aid);
                return rt;
            }

            // TODO 这里省略较多跟业务相关代码，请自行填充

            // 获取数据库连接
            Dao dao = m_daoPool.getDao();
            if (dao == null) {
                rt = Errno.DAO_CONN_ERROR;
                Log.logErr(rt,"dao null err; flow=%d, aid=%d", flow, aid);
                return rt;
            }

            FaiList<Param> list;
            // 加锁语句要在 try 代码块之前
            m_lock.readLock(aid);
            try {
                // TODO 这里省略较多跟业务相关代码，请自行填充

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
                }
            } finally {
                m_lock.readUnlock(aid);
            }
            rt = Errno.OK;
            FaiBuffer sendBuf = new FaiBuffer(true);
            list.toBuffer(sendBuf, ${entity.name.def}.Protocol.Key.INFO_LIST, ${entity.name.def}.Protocol.get${entity.name.def}());
            if (searchArg.totalSize != null && searchArg.totalSize.value != null) {
                sendBuf.putInt(${entity.name.def}.Protocol.Key.TOTAL_SIZE, searchArg.totalSize.value);
            }
            sendProtocol.addEncodeBody(sendBuf);
        } finally {
            stat.end((rt != Errno.OK && rt != Errno.NOT_FOUND), rt);
        }
        return rt;
    }


    protected static final String TABLE_NAME = "${table.name}";

    private DaoPool m_daoPool;
    private RedisCacheManager m_cache;
    private PosReadWriteLock m_lock;
    private Param m_svrOption;

}