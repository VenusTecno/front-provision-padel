# Etapa 1: Construção da aplicação
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

#ENV VITE_API_BASE_URL=https://api-score-board.vercel.app
#ENV VITE_WEBSOCKT_BASE_URL=https://wahitechdicbackoffice.biscatos.com/api
#ENV VITE_API_BASE_URL=http://10.11.1.190:9902
#ENV VITE_WEBSOCKT_BASE_URL=http://10.11.1.190:9903
ENV VITE_API_BASE_URL=https://apiscore.jokerpadelhub.co.ao
ENV VITE_WEBSOCKT_BASE_URL=https://serv.jokerpadelhub.co.ao
RUN npm run build

# Etapa 2: Servir o app com Nginx
FROM nginx:alpine AS production

COPY --from=builder /app/dist /usr/share/nginx/html

# ✅ Copiando a configuração correta do Nginx para suportar SPA
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
