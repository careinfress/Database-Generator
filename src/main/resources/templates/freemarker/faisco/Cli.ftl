${gen.setType("cli")}
package ${entity.packages.cli};

import fai.app.*;
import fai.comm.util.*;
import fai.comm.netkit.FaiClient;
import fai.comm.netkit.FaiProtocol;

/**
 * client ${entity.comment}
 *
 * @author ${developer.author}
 * @date ${date.toString("yyyy-MM-dd HH:mm:ss")}
 */
public class ${entity.name.cli} extends FaiClient {

    public ${entity.name.cli}(int flow) {
        super(flow, "${entity.name.cli}");
    }

    /**
     * 初始化 默认使用配置中心配置
     *
     */
    public boolean init() {
        return init("${entity.name.cli}", true);
    }

    /**
     * 业务处理：保存添加 <strong>${entity.comment}</strong>
     *
     * @param info ${entity.comment}
     * @return 请求处理结果
     */
    public int add${entity.name}(Param info) {
        return add${entity.name}(0, info, null);
    }

    /**
     * 业务处理：保存添加 <strong>${entity.comment}</strong>
     *
     * @param aid  用户标志ID
     * @param info ${entity.comment}
     * @return 请求处理结果
     */
    public int add${entity.name}(int aid, Param info) {
        return add${entity.name}(aid, info, null);
    }

    /**
     * 业务处理：保存添加 <strong>${entity.comment}</strong>
     *
     * @param aid  用户标志ID
     * @param info ${entity.comment}
     * @param idRef 返回值封装
     * @return 请求处理结果
     */
    public int add${entity.name}(int aid, Param info, Ref<Integer> idRef) {
        m_rt = Errno.ERROR;
        Oss.CliStat stat = new Oss.CliStat(m_name, m_flow);
        try {
            // 数据校验
            if (info == null || info.isEmpty()) {
                m_rt = Errno.ARGS_ERROR;
                Log.logErr(m_rt, "args error");
                return m_rt;
            }
            // 编码
            FaiBuffer sendBody = new FaiBuffer(true);
            info.toBuffer(sendBody, ${entity.name.def}.Protocol.Key.INFO, ${entity.name.def}.Protocol.get${entity.name.def}());
            FaiProtocol sendProtocol = new FaiProtocol();
            if (aid > 0) {
                sendProtocol.setAid(aid);
            }
            sendProtocol.setCmd(${entity.name.def}.Protocol.Cmd.ADD);
            sendProtocol.addEncodeBody(sendBody);
            // 发送数据
            m_rt = send(sendProtocol);
            if (m_rt != Errno.OK) {
                Log.logErr(m_rt, "send err");
                return m_rt;
            }

            // 接收数据
            FaiProtocol recvProtocol = new FaiProtocol();
            m_rt = recv(recvProtocol);
            if (m_rt != Errno.OK) {
                Log.logErr(m_rt, "recv err");
                return m_rt;
            }
            // 获取处理结果（head头信息）
            m_rt = recvProtocol.getResult();
            if (m_rt != Errno.OK) {
                Log.logErr(m_rt, "recv result err");
                return m_rt;
            }
            // 获取包体
            if (idRef != null) {
                // 解码
                FaiBuffer recvBody = recvProtocol.getDecodeBody();
                if (recvBody == null) {
                    m_rt = Errno.CODEC_ERROR;
                    Log.logErr(m_rt, "recv body null");
                    return m_rt;
                }
                Ref<Integer> keyRef = new Ref<Integer>();
                m_rt = recvBody.getInt(keyRef, idRef);
                if (m_rt != Errno.OK || keyRef.value != ${entity.name.def}.Protocol.Key.ID) {
                    Log.logErr(m_rt, "recv codec err");
                    return m_rt;
                }
            }
            m_rt = Errno.OK;
            return m_rt;
        } finally {
            close();
            stat.end(m_rt != Errno.OK, m_rt);
        }
    }

    /**
     * 业务处理：修改更新 <strong>${entity.comment}</strong>
     *
     * @param id   主键ID
     * @param updater 更新的操作封装
     * @return 请求处理结果
     */
    public int set${entity.name}(int id, ParamUpdater updater) {
        return set${entity.name}(0, id, updater);
    }

    /**
     * 业务处理：修改更新 <strong>${entity.comment}</strong>
     *
     * @param aid  用户标志ID
     * @param id   主键ID
     * @param updater 更新的操作封装
     * @return 请求处理结果
     */
    public int set${entity.name}(int aid, int id, ParamUpdater updater) {
        m_rt = Errno.ERROR;
        Oss.CliStat stat = new Oss.CliStat(m_name, m_flow);
        try {
            // 数据校验
            if (id <= 0 || updater == null || updater.isEmpty()) {
                m_rt = Errno.ARGS_ERROR;
                Log.logErr(m_rt, "args error;aid=%d, id=%d", aid, id);
                return m_rt;
            }
            // 编码
            FaiBuffer sendBody = new FaiBuffer(true);
            sendBody.putInt(${entity.name.def}.Protocol.Key.ID, id);
            updater.toBuffer(sendBody, ${entity.name.def}.Protocol.Key.UPDATER, ${entity.name.def}.Protocol.get${entity.name.def}());

            FaiProtocol sendProtocol = new FaiProtocol();
            if (aid > 0) {
                sendProtocol.setAid(aid);
            }
            sendProtocol.setCmd(${entity.name.def}.Protocol.Cmd.SET);
            sendProtocol.addEncodeBody(sendBody);
            // 发送数据
            m_rt = send(sendProtocol);
            if (m_rt != Errno.OK) {
                Log.logErr(m_rt, "send err");
                return m_rt;
            }

            // 接收数据
            FaiProtocol recvProtocol = new FaiProtocol();
            m_rt = recv(recvProtocol);
            if (m_rt != Errno.OK) {
                Log.logErr(m_rt, "recv err");
                return m_rt;
            }
            // 获取处理结果（head头信息）
            m_rt = recvProtocol.getResult();
            if (m_rt != Errno.OK) {
                Log.logErr(m_rt, "recv result err");
                return m_rt;
            }
            m_rt = Errno.OK;
            return m_rt;
        } finally {
            close();
            stat.end(m_rt != Errno.OK, m_rt);
        }
    }

    /**
     * 业务处理：删除 <strong>${entity.comment}</strong>
     *
     * @param id   主键ID
     * @param matcher 选择条件封装
     * @return 请求处理结果
     */
    public int del${entity.name}(int id, ParamMatcher matcher) {
    	return del${entity.name}(0, id, matcher);
    }

    /**
     * 业务处理：删除 <strong>${entity.comment}</strong>
     *
     * @param aid  用户标志ID
     * @param id   主键ID
     * @param matcher 选择条件封装
     * @return 请求处理结果
     */
    public int del${entity.name}(int aid, int id, ParamMatcher matcher) {
        m_rt = Errno.ERROR;
        Oss.CliStat stat = new Oss.CliStat(m_name, m_flow);
        try {
            // 数据校验
            if (id <= 0 || matcher == null) {
                m_rt = Errno.ARGS_ERROR;
                Log.logErr(m_rt, "args error;aid=%d, id=%d", aid, id);
                return m_rt;
            }
            // 编码
            FaiBuffer sendBody = new FaiBuffer(true);
            matcher.toBuffer(sendBody, ${entity.name.def}.Protocol.Key.MATCHER);
            sendBody.putInt(${entity.name.def}.Protocol.Key.ID, id);
            FaiProtocol sendProtocol = new FaiProtocol();
            if (aid > 0) {
                sendProtocol.setAid(aid);
            }
            sendProtocol.setCmd(${entity.name.def}.Protocol.Cmd.DEL);
            sendProtocol.addEncodeBody(sendBody);
            // 发送数据
            m_rt = send(sendProtocol);
            if (m_rt != Errno.OK) {
                Log.logErr(m_rt, "send err");
                return m_rt;
            }

            // 接收数据
            FaiProtocol recvProtocol = new FaiProtocol();
            m_rt = recv(recvProtocol);
            if (m_rt != Errno.OK) {
                Log.logErr(m_rt, "recv err");
                return m_rt;
            }
            // 获取处理结果（head头信息）
            m_rt = recvProtocol.getResult();
            if (m_rt != Errno.OK) {
                Log.logErr(m_rt, "recv result err");
                return m_rt;
            }
            m_rt = Errno.OK;
            return m_rt;
        } finally {
            close();
            stat.end(m_rt != Errno.OK, m_rt);
        }
    }

	/**
     * 业务处理：获取一条记录 <strong>${entity.comment}</strong>
     *
     * @param id   主键ID
     * @param info ${entity.comment}
     * @return 请求处理结果
     */
    public int get${entity.name}(int id, Param info) {
    	return get${entity.name}(0, id, info);
    }

    /**
     * 业务处理：获取一条记录 <strong>${entity.comment}</strong>
     *
     * @param aid  用户标志ID
     * @param id   主键ID
     * @param info ${entity.comment}
     * @return 请求处理结果
     */
    public int get${entity.name}(int aid, int id, Param info) {
        m_rt = Errno.ERROR;
        Oss.CliStat stat = new Oss.CliStat(m_name, m_flow);
        try {
            // 数据校验
            if (id <= 0 || info == null) {
                m_rt = Errno.ARGS_ERROR;
                Log.logErr(m_rt, "args error;aid=%d, id=%d", aid, id);
                return m_rt;
            }
            // 编码
            FaiBuffer sendBody = new FaiBuffer(true);
            sendBody.putInt(${entity.name.def}.Protocol.Key.ID, id);
            FaiProtocol sendProtocol = new FaiProtocol();
            if (aid > 0) {
                sendProtocol.setAid(aid);
            }
            sendProtocol.setCmd(${entity.name.def}.Protocol.Cmd.GET);
            sendProtocol.addEncodeBody(sendBody);
            // 发送数据
            m_rt = send(sendProtocol);
            if (m_rt != Errno.OK) {
                Log.logErr(m_rt, "send err");
                return m_rt;
            }

            // 接收数据
            FaiProtocol recvProtocol = new FaiProtocol();
            m_rt = recv(recvProtocol);
            if (m_rt != Errno.OK) {
                Log.logErr(m_rt, "recv err");
                return m_rt;
            }
            // 获取处理结果（head头信息）
            m_rt = recvProtocol.getResult();
            if (m_rt != Errno.OK && m_rt != Errno.NOT_FOUND) {
                Log.logErr(m_rt, "recv result err");
                return m_rt;
            }
            // 获取包体
            FaiBuffer recvBody = recvProtocol.getDecodeBody();
            if (recvBody == null) {
                m_rt = Errno.CODEC_ERROR;
                Log.logErr(m_rt, "recv body null");
                return m_rt;
            }
            // 解码
            Ref<Integer> keyRef = new Ref<Integer>();
			m_rt = info.fromBuffer(recvBody, keyRef, ${entity.name.def}.Protocol.get${entity.name.def}());
			if (m_rt != Errno.OK || keyRef.value != ${entity.name.def}.Protocol.Key.INFO) {
				Log.logErr(m_rt, "recv info codec err");
				return m_rt;
			}
            m_rt = Errno.OK;
            return m_rt;
        } finally {
            close();
            stat.end((m_rt != Errno.OK) && (m_rt != Errno.NOT_FOUND), m_rt);
        }
    }

    /**
     * 业务处理：获取记录集 <strong>${entity.comment}</strong>
     *
     * @param searchArg 查询条件封装
     * @param list 记录集
     * @return 请求处理结果
     */
    public int get${entity.name}List(SearchArg searchArg, FaiList<Param> list) {
    	return get${entity.name}List(0, searchArg, list);
    }

    /**
     * 业务处理：获取记录集 <strong>${entity.comment}</strong>
     *
     * @param aid  用户标志ID
     * @param searchArg 查询条件封装
     * @param list 记录集
     * @return 请求处理结果
     */
    public int get${entity.name}List(int aid, SearchArg searchArg, FaiList<Param> list) {
        m_rt = Errno.ERROR;
        Oss.CliStat stat = new Oss.CliStat(m_name, m_flow);
        try {
            // 数据校验
            if (searchArg == null || list == null) {
                m_rt = Errno.ARGS_ERROR;
                Log.logErr(m_rt, "args error");
                return m_rt;
            }
            // 编码
            FaiBuffer sendBody = new FaiBuffer(true);
            searchArg.toBuffer(sendBody, ${entity.name.def}.Protocol.Key.SEARCH_ARG);
            FaiProtocol sendProtocol = new FaiProtocol();
            if (aid > 0) {
                sendProtocol.setAid(aid);
            }
            sendProtocol.setCmd(${entity.name.def}.Protocol.Cmd.GET_LIST);
            sendProtocol.addEncodeBody(sendBody);
            // 发送数据
            m_rt = send(sendProtocol);
            if (m_rt != Errno.OK) {
                Log.logErr(m_rt, "send err");
                return m_rt;
            }

            // 接收数据
            FaiProtocol recvProtocol = new FaiProtocol();
            m_rt = recv(recvProtocol);
            if (m_rt != Errno.OK) {
                Log.logErr(m_rt, "recv err");
                return m_rt;
            }
            // 获取处理结果（head头信息）
            m_rt = recvProtocol.getResult();
            if (m_rt != Errno.OK && m_rt != Errno.NOT_FOUND) {
                Log.logErr(m_rt, "recv result err");
                return m_rt;
            }
            // 获取包体
            FaiBuffer recvBody = recvProtocol.getDecodeBody();
            if (recvBody == null) {
                m_rt = Errno.CODEC_ERROR;
                Log.logErr(m_rt, "recv body null");
                return m_rt;
            }
            // 解码
            Ref<Integer> keyRef = new Ref<Integer>();
			m_rt = list.fromBuffer(recvBody, keyRef, ${entity.name.def}.Protocol.get${entity.name.def}());
			if (m_rt != Errno.OK || keyRef.value != ${entity.name.def}.Protocol.Key.INFO_LIST) {
				Log.logErr(m_rt, "recv info codec err");
				return m_rt;
			}
			// 获取总条数
			if (searchArg.totalSize != null) {
				recvBody.getInt(keyRef, searchArg.totalSize);
				if (keyRef.value != ${entity.name.def}.Protocol.Key.TOTAL_SIZE) {
					m_rt = Errno.ERROR;
					Log.logErr(m_rt, "recv total size null");
					return m_rt;
				}
			}
            m_rt = Errno.OK;
            return m_rt;
        } finally {
            close();
            stat.end((m_rt != Errno.OK) && (m_rt != Errno.NOT_FOUND), m_rt);
        }
    }


}