FROM node:22-alpine
WORKDIR /app
# ffmpeg gera os vídeos verticais; font-dejavu é a fonte reserva caso as fontes Jost não subam
RUN apk add --no-cache ffmpeg font-dejavu
COPY . .
# Fontes do vídeo: usa as Jost do repositório (onde estiverem) ou a fonte do sistema
RUN mkdir -p assets/fontes /app/data && for f in Jost-Light Jost-Regular; do [ -f assets/fontes/$f.ttf ] || cp "$(find . -name "$f.ttf" -not -path "./assets/*" | head -1)" assets/fontes/$f.ttf 2>/dev/null || cp "$(find /usr/share/fonts -name '*.ttf' | head -1)" assets/fontes/$f.ttf 2>/dev/null || true; done
ENV NODE_ENV=production
EXPOSE 3000
# Acha o servidor mesmo que o código tenha subido dentro de uma subpasta
CMD ["sh", "-c", "exec node \"$(find /app -path '*/src/server.js' -not -path '*/node_modules/*' | head -1)\""]
