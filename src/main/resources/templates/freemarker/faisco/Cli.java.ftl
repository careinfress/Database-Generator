${gen.setType("cli")}
package ${entity.packages.cli};

import fai.comm.util.*;
import fai.app.*;
import fai.comm.cli.*;

${entity.packages}

public class ${entity.name.cli} extends FaiClient {

    public ${entity.name.cli}(int flow) {
        super(flow, "${entity.name.cli}");
    }
    public boolean init() {
        return init("${entity.name.cli}", true);
    }

    /**
     * 业务处理：保存一个 <strong>${entity.comment}</strong>
     *
     * @param info ${entity.comment}
     * @param idRef 返回值封装
     */
    public int add${entity.name}(Param info, Ref<Integer> idRef) {
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
            info.toBuffer(sendBody, ${entity.name.def}.Protocol.Key.${entity.name}Info, ${entity.name.def}.Protocol.get${entity.name.def}());
            FaiProtocol sendProtocol = new FaiProtocol();
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
            // recv id
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

}